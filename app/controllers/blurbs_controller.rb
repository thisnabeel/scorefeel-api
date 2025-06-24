class BlurbsController < BaseController
  before_action :set_blurb, only: [:show, :update, :destroy]

  def index
    @blurbs = Blurb.includes(:blurbable).ordered
    render json: @blurbs
  end

  def show
    render json: @blurb
  end

  def create
    @blurb = Blurb.new(blurb_params)
    
    if @blurb.save
      render json: @blurb, status: :created
    else
      render json: { errors: @blurb.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @blurb.update(blurb_params)
      render json: @blurb
    else
      render json: { errors: @blurb.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @blurb.destroy
    head :no_content
  end

  def for_blurbable
    blurbable_type = params[:blurbable_type].classify
    blurbable_id = params[:blurbable_id]
    
    @blurbs = Blurb.for_blurbable(blurbable_type, blurbable_id).includes(:blurbable).ordered
    
    render json: @blurbs
  rescue NameError
    render json: { error: "Invalid blurbable type: #{params[:blurbable_type]}" }, status: :bad_request
  end

  def wizard
    blurbable_type = params[:blurbable_type].classify
    blurbable_id = params[:blurbable_id]
    
    begin
      blurbable_class = blurbable_type.constantize
      blurbable = blurbable_class.find(blurbable_id)
      
      # Build content for the prompt
      content = blurbable.title
      if blurbable.respond_to?(:body) && blurbable.body.present?
        content += "\n\n#{blurbable.body}"
      elsif blurbable.respond_to?(:summary) && blurbable.summary.present?
        content += "\n\n#{blurbable.summary}"
      end
      
      prompt = "Generate 5 interesting fact blurbs (with prefix emoji) that would look great as rounded pills in a UI. These should be short, engaging facts that highlight key points about this content. Return as JSON array with objects like this exactly: [{\"title\": \"🔥 Quick Fact Title\", \"description\": \"Brief fact description\"}, ...]. Keep titles under 20 characters and descriptions under 100 characters. Here's the content:\n\n#{content}"
      
      blurbs_data = WizardService.ask(prompt, "json_object")
      
      # Handle nested response structure
      if blurbs_data.is_a?(Hash) && blurbs_data.keys.length == 1
        blurbs_data = blurbs_data[blurbs_data.keys.first]
      end
      
      # Ensure we have an array to work with
      if blurbs_data.is_a?(Hash)
        # If it's a single object, wrap it in an array
        blurbs_data = [blurbs_data]
      elsif !blurbs_data.is_a?(Array)
        raise "Invalid response format: expected array or object, got #{blurbs_data.class}"
      end
      
      created_blurbs = []
      blurbs_data.each do |blurb_data|
        next unless blurb_data.is_a?(Hash) && blurb_data["title"] && blurb_data["description"]
        
        blurb = Blurb.create!(
          title: blurb_data["title"],
          description: blurb_data["description"],
          blurbable_type: blurbable_type,
          blurbable_id: blurbable_id,
          starred: true
        )
        created_blurbs << blurb
      end
      
      render json: {
        message: "Successfully generated #{created_blurbs.count} fact blurbs for #{blurbable_type} ##{blurbable_id}",
        blurbs: created_blurbs
      }, status: :created
      
    rescue NameError
      render json: { error: "Invalid blurbable type: #{params[:blurbable_type]}" }, status: :bad_request
    rescue ActiveRecord::RecordNotFound
      render json: { error: "#{blurbable_type} not found" }, status: :not_found
    rescue => e
      Rails.logger.error "Blurb wizard error: #{e.message}"
      render json: { 
        error: "Failed to generate blurbs", 
        details: e.message 
      }, status: :unprocessable_entity
    end
  end

  private

  def set_blurb
    @blurb = Blurb.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Blurb not found' }, status: :not_found
  end

  def blurb_params
    params.require(:blurb).permit(:title, :description, :blurbable_type, :blurbable_id, :starred)
  end
end 