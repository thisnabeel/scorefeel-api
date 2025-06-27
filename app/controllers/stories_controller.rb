class StoriesController < BaseController
  before_action :set_story, only: [:show, :update, :destroy, :generate_pictures, :generate_blurbs, :upload_picture, :validate]

  def index
    if params[:figure_id]
      @stories = Story.where(storyable_type: 'Figure', storyable_id: params[:figure_id]).includes(:storyable, :tags).ordered
    elsif params[:sport_id]
      sport = Sport.find(params[:sport_id])
      @stories = sport.all_stories
    else
      @stories = Story.includes(:storyable, :tags).ordered
    end
    render json: @stories.as_json(include: [:storyable, :tags, :pictures])
  end

  def show
    render json: @story.as_json(include: [:storyable, :tags, :pictures, :bullet_points, :blurbs])
  end

  def create
    @story = Story.new(story_params)
    
    if @story.save
      render json: @story.as_json(include: [:storyable, :tags]), status: :created
    else
      render json: { errors: @story.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @story.update(story_params)
      render json: @story.as_json(include: [:storyable, :tags])
    else
      render json: { errors: @story.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @story.destroy
    head :no_content
  end

  def generate_pictures
    story = Story.find(params[:id])
    
    prompt = "Give me the best search terms for finding cover images for this article. Generate 3 different search terms that would be effective for finding compelling images. Return as JSON array with objects like this exactly: [{\"caption\": \"Search term 1\", \"cover\": true}, {\"caption\": \"Search term 2\", \"cover\": false}, {\"caption\": \"Search term 3\", \"cover\": false}]. The first one should be the best cover image search term. Here's the article:\n\n#{story.title}\nPublished on #{story.created_at.strftime('%B %d, %Y')}\n\n#{story.title}\n#{story.body}"
    
    begin
      pictures_data = WizardService.ask(prompt, "json_object")
      puts "Generated pictures data: #{pictures_data}"
      
      if pictures_data.is_a?(Hash)
        pictures_data = pictures_data[pictures_data.keys.first]
      end
      
      created_pictures = []
      pictures_data.each do |picture_data|
        picture = story.pictures.create!(
          caption: picture_data["caption"],
          cover: picture_data["cover"] || false
        )
        created_pictures << picture
      end
      
      render json: {
        message: "Successfully generated #{created_pictures.count} picture suggestions for '#{story.title}'",
        pictures: created_pictures
      }, status: :created
      
    rescue => e
      puts "Error: #{e.message}"
      render json: { 
        error: "Failed to generate picture suggestions", 
        details: e.message 
      }, status: :unprocessable_entity
    end
  end

  def generate_blurbs
    story = Story.find(params[:id])
    
    prompt = "Generate 3 compelling rounded pill blurbs for this story. Each blurb should be a concise, engaging summary that captures the essence of the story and entices readers. Return as JSON array with objects like this exactly: [{\"title\": \"Blurb Title 1\", \"description\": \"Blurb description 1\", \"starred\": true}, {\"title\": \"Blurb Title 2\", \"description\": \"Blurb description 2\", \"starred\": false}, {\"title\": \"Blurb Title 3\", \"description\": \"Blurb description 3\", \"starred\": false}]. The first one should be the best/most compelling blurb. Here's the story:\n\n#{story.title}\nPublished on #{story.created_at.strftime('%B %d, %Y')}\n\n#{story.title}\n#{story.body}\n bullet points: #{story.bullet_points.map(&:body).join(', ')}"
    
    begin
      blurbs_data = WizardService.ask(prompt, "json_object")
      puts "Generated blurbs data: #{blurbs_data}"
      
      # Handle different response formats
      if blurbs_data.is_a?(Hash)
        if blurbs_data.keys.length == 1
          blurbs_data = blurbs_data[blurbs_data.keys.first]
        end
        
        # If it's still a single object, wrap it in an array
        if blurbs_data.is_a?(Hash) && blurbs_data.key?("title")
          blurbs_data = [blurbs_data]
        end
      end
      
      # Ensure we have an array
      blurbs_data = [blurbs_data] unless blurbs_data.is_a?(Array)
      
      created_blurbs = []
      blurbs_data.each do |blurb_data|
        blurb = story.blurbs.create!(
          title: blurb_data["title"],
          description: blurb_data["description"],
          starred: blurb_data["starred"] || false
        )
        created_blurbs << blurb
      end
      
      render json: {
        message: "Successfully generated #{created_blurbs.count} blurbs for '#{story.title}'",
        blurbs: created_blurbs
      }, status: :created
      
    rescue => e
      puts "Error: #{e.message}"
      render json: { 
        error: "Failed to generate blurbs", 
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
      picture = @story.pictures.create!(
        caption: params[:caption] || "Picture for #{@story.title}",
        cover: @story.pictures.count == 0 ? true : false
      )
      file_upload = FileStorageService.upload(params[:file], "stories/#{@story.id}/pictures/", params[:file].original_filename)
      picture.update!(
        image_url: file_upload[:url],
        storage_key: file_upload[:key]
      )
      
      render json: {
        message: "Successfully uploaded picture for '#{@story.title}'",
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

  def validate
    prompt = "Please analyze the following story for accuracy and truthfulness. Consider historical facts, logical consistency, and verifiable information. Return your analysis as a JSON object with the following structure exactly:\n\n{\n  \"is_accurate\": true/false,\n  \"confidence_score\": 0-100,\n  \"issues_found\": [\"list of specific issues or concerns\"],\n  \"verification_notes\": \"detailed explanation of your assessment\",\n  \"recommendations\": [\"suggestions for improvement or verification\"]\n}\n\nStory Title: #{@story.title}\n\nStory Content:\n#{@story.body}"
    
    begin
      validation_result = WizardService.ask(prompt, "json_object")
      
      # Handle nested response structure
      if validation_result.is_a?(Hash) && validation_result.keys.length == 1
        validation_result = validation_result[validation_result.keys.first]
      end
      
      render json: {
        story_id: @story.id,
        story_title: @story.title,
        validation: validation_result
      }, status: :ok
      
    rescue => e
      Rails.logger.error "Story validation error: #{e.message}"
      render json: { 
        error: "Failed to validate story", 
        details: e.message 
      }, status: :unprocessable_entity
    end
  end

  private

  def set_story
    @story = Story.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Story not found' }, status: :not_found
  end

  def story_params
    params.require(:story).permit(:title, :body, :storyable_type, :storyable_id)
  end
end
