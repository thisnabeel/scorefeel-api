class StoriesController < BaseController
  before_action :set_story, only: [:show, :update, :destroy, :generate_pictures, :upload_picture]

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
    render json: @story.as_json(include: [:storyable, :tags, :pictures])
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
