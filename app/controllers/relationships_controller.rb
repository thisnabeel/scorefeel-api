class RelationshipsController < BaseController
  before_action :set_relationship, only: [:show, :update, :destroy]

  def index
    @relationships = Relationship.includes(:figures, :tags).all
    render json: @relationships.as_json(include: [:figures, :tags])
  end

  def show
    render json: @relationship.as_json(include: [:figures, :tags, :events, :stories])
  end

  def create
    @relationship = Relationship.new(relationship_params)
    
    if @relationship.save
      render json: @relationship.as_json(include: [:figures, :tags]), status: :created
    else
      render json: { errors: @relationship.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @relationship.update(relationship_params)
      render json: @relationship.as_json(include: [:figures, :tags])
    else
      render json: { errors: @relationship.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @relationship.destroy
    head :no_content
  end

  private

  def set_relationship
    @relationship = Relationship.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Relationship not found' }, status: :not_found
  end

  def relationship_params
    params.require(:relationship).permit(:title)
  end
end
