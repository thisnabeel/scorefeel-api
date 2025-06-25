class BulletPointsController < BaseController
  before_action :set_bullet_point, only: [:show, :update, :destroy]

  def index
    @bullet_points = BulletPoint.includes(:bullet_pointable).ordered
    render json: @bullet_points
  end

  def show
    render json: @bullet_point
  end

  def create
    @bullet_point = BulletPoint.new(bullet_point_params)
    
    if @bullet_point.save
      render json: @bullet_point, status: :created
    else
      render json: { errors: @bullet_point.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @bullet_point.update(bullet_point_params)
      render json: @bullet_point
    else
      render json: { errors: @bullet_point.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @bullet_point.destroy
    head :no_content
  end

  def for_bullet_pointable
    bullet_pointable_type = params[:bullet_pointable_type].classify
    bullet_pointable_id = params[:bullet_pointable_id]
    
    @bullet_points = BulletPoint.for_bullet_pointable(bullet_pointable_type, bullet_pointable_id).includes(:bullet_pointable).ordered
    
    render json: @bullet_points
  rescue NameError
    render json: { error: "Invalid bullet_pointable type: #{params[:bullet_pointable_type]}" }, status: :bad_request
  end

  def wizard
    bullet_pointable_type = params[:bullet_pointable_type].classify
    bullet_pointable_id = params[:bullet_pointable_id]
    
    result = BulletPoint.wizard(bullet_pointable_type, bullet_pointable_id)
    
    if result[:success]
      render json: result, status: :created
    else
      render json: { error: result[:error], details: result[:details] }, status: :unprocessable_entity
    end
  rescue NameError
    render json: { error: "Invalid bullet_pointable type: #{params[:bullet_pointable_type]}" }, status: :bad_request
  end

  private

  def set_bullet_point
    @bullet_point = BulletPoint.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Bullet point not found' }, status: :not_found
  end

  def bullet_point_params
    params.require(:bullet_point).permit(:body, :bullet_pointable_type, :bullet_pointable_id, :position)
  end
end 