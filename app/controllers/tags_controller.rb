class TagsController < BaseController
  before_action :set_tag, only: [:show, :update, :destroy]

  def index
    @tags = Tag.includes(:figures, :sports, :sport_rules, :relationships, :events, :stories).ordered
    render json: @tags.as_json(include: [:figures, :sports, :sport_rules, :relationships, :events, :stories])
  end

  def show
    render json: @tag.as_json(include: [:figures, :sports, :sport_rules, :relationships, :events, :stories])
  end

  def create
    @tag = Tag.new(tag_params)
    
    if @tag.save
      render json: @tag.as_json(include: [:figures, :sports, :sport_rules, :relationships, :events, :stories]), status: :created
    else
      render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @tag.update(tag_params)
      render json: @tag.as_json(include: [:figures, :sports, :sport_rules, :relationships, :events, :stories])
    else
      render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    head :no_content
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Tag not found' }, status: :not_found
  end

  def tag_params
    params.require(:tag).permit(:title, :summary)
  end
end
