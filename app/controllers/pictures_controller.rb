class PicturesController < BaseController
  before_action :set_picture, only: [:show, :update, :destroy, :upload_picture]

  def index
    if params[:story_id]
      @pictures = Picture.where(picturable_type: 'Story', picturable_id: params[:story_id]).includes(:picturable).ordered
    else
      @pictures = Picture.includes(:picturable).ordered
    end
    render json: @pictures.as_json(include: [:picturable])
  end

  def show
    render json: @picture.as_json(include: [:picturable])
  end

  def create
    @picture = Picture.new(picture_params)
    
    if @picture.save
      render json: @picture.as_json(include: [:picturable]), status: :created
    else
      render json: { errors: @picture.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @picture.update(picture_params)
      render json: @picture.as_json(include: [:picturable])
    else
      render json: { errors: @picture.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @picture.destroy
    head :no_content
  end

  def upload_picture
    unless params[:file]
      render json: { error: "No file provided" }, status: :unprocessable_entity
      return
    end

    begin
      # Determine the storage path based on the picturable type
      picturable_type = @picture.picturable_type.downcase
      picturable_id = @picture.picturable_id
      storage_path = "#{picturable_type}s/#{picturable_id}/pictures/"
      
      # Upload the file using FileStorageService
      file_upload = FileStorageService.upload(params[:file], storage_path, params[:file].original_filename)
      
      # Update the picture record with new file information
      @picture.update!(
        image_url: file_upload[:url],
        storage_key: file_upload[:key]
      )
      
      render json: {
        message: "Successfully uploaded image for picture '#{@picture.caption}'",
        picture: @picture
      }, status: :ok
      
    rescue => e
      puts "Error: #{e.message}"
      render json: { 
        error: "Failed to upload image", 
        details: e.message 
      }, status: :unprocessable_entity
    end
  end

  private

  def set_picture
    @picture = Picture.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Picture not found' }, status: :not_found
  end

  def picture_params
    params.require(:picture).permit(:caption, :image_url, :storage_key, :cover, :picturable_type, :picturable_id)
  end
end
