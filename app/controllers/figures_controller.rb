class FiguresController < BaseController
  before_action :set_figure, only: [:show, :update, :destroy, :generate_story, :upload_picture]
  before_action :set_sport, only: [:index]

  def index
    if @sport
      @figures = @sport.figures.includes(:sport, :tags).ordered
    else
      @figures = Figure.includes(:sport, :tags).ordered
    end
    render json: @figures
  end

  def show
    render json: @figure
  end

  def create
    @figure = Figure.new(figure_params)
    
    if @figure.save
      render json: @figure, status: :created
    else
      render json: { errors: @figure.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @figure.update(figure_params)
      render json: @figure
    else
      render json: { errors: @figure.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @figure.destroy
    head :no_content
  end

  def generate_story
    prompt = "Write an engaging story about #{@figure.title}, a #{@figure.sport.title} figure. Make it about a specific pivotal moment in their career. The story should be compelling and informative. Return as JSON with title and body fields: {\"title\": \"Story Title\", \"body\": \"Story content here as HTML formatted text as one big text...\"}"
    
    begin
      story_data = WizardService.ask(prompt, "json_object")
      puts "Generated story: #{story_data}"
      
      story = @figure.stories.create!(
        title: story_data["title"],
        body: story_data["body"]
      )
      
      render json: {
        message: "Successfully generated story for #{@figure.title}",
        story: story
      }, status: :created
      
    rescue => e
      puts "Error: #{e.message}"
      render json: { 
        error: "Failed to generate story", 
        details: e.message 
      }, status: :unprocessable_entity
    end
  end

  def upload_picture
    unless params[:file]
      render json: { error: "No file provided" }, status: :unprocessable_entity
      return
    end

    begin
      params[:file].original_filename
      picture = @figure.pictures.create!(
        caption: params[:caption] || "Picture of #{@figure.title}",
        cover: @figure.pictures.count == 0 ? true : false
      )
      file_upload = FileStorageService.upload(params[:file], "figures/#{@figure.id}/pictures/", params[:file].original_filename)
      picture.update!(
        image_url: file_upload[:url],
        storage_key: file_upload[:key]
      )
      
      render json: {
        message: "Successfully uploaded picture for #{@figure.title}",
        picture: picture
      }, status: :created
      
    rescue => e
      puts "Error: #{e.message}"
      render json: { 
        error: "Failed to upload picture", 
        details: e.message 
      }, status: :unprocessable_entity
    end
  end

  private

  def set_sport
    @sport = Sport.find(params[:sport_id])
  end

  def set_figure
    @figure = Figure.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Figure not found' }, status: :not_found
  end

  def figure_params
    params.require(:figure).permit(:title, :summary, :birth_date, :death_date, :sport_id, :position)
  end
end
