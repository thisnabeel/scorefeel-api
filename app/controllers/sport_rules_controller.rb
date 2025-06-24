class SportRulesController < BaseController
  before_action :set_sport_rule, only: [:show, :update, :destroy]

  def index
    if params[:sport_id]
      @sport_rules = SportRule.where(sport_id: params[:sport_id]).includes(:sport, :tags).ordered
    else
      @sport_rules = SportRule.includes(:sport, :tags).ordered
    end
    render json: @sport_rules.as_json(include: [:sport, :tags])
  end

  def show
    render json: @sport_rule.as_json(include: [:sport, :tags, :events, :stories])
  end

  def create
    @sport_rule = SportRule.new(sport_rule_params)
    
    if @sport_rule.save
      render json: @sport_rule.as_json(include: [:sport, :tags]), status: :created
    else
      render json: { errors: @sport_rule.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @sport_rule.update(sport_rule_params)
      render json: @sport_rule.as_json(include: [:sport, :tags])
    else
      render json: { errors: @sport_rule.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @sport_rule.destroy
    head :no_content
  end

  private

  def set_sport_rule
    @sport_rule = SportRule.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Sport rule not found' }, status: :not_found
  end

  def sport_rule_params
    params.require(:sport_rule).permit(:title, :summary, :body, :sport_id)
  end
end
