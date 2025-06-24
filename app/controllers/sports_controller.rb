class SportsController < BaseController
  before_action :set_sport, only: [:show, :update, :destroy, :generate_figures, :generate_sport_rules, :generate_story, :generate_events]

  def index
    @sports = Sport.includes(:figures, :sport_rules, :tags).ordered
    render json: @sports.as_json(include: [:figures, :sport_rules, :tags])
  end

  def show
    render json: @sport.as_json(include: [:figures, :sport_rules, :tags, :events, :stories])
  end

  def create
    @sport = Sport.new(sport_params)
    
    if @sport.save
      render json: @sport.as_json(include: [:figures, :sport_rules, :tags]), status: :created
    else
      render json: { errors: @sport.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @sport.update(sport_params)
      render json: @sport.as_json(include: [:figures, :sport_rules, :tags])
    else
      render json: { errors: @sport.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @sport.destroy
    head :no_content
  end

  def generate_figures
    # Get existing figure names to avoid duplicates
    existing_figures = @sport.figures.pluck(:title)
    
    prompt = "Generate 5 famous #{@sport.title} figures/athletes that are not in this list: #{existing_figures.join(', ')}. For each figure, provide: name and a brief description. Return as JSON exactly 1 array with objects like this exactly unnested => [{\"title\": \"name\", \"summary\": \"summary\", \"birth_date\": \"birth_date\", \"death_date\": \"death_date\"}, ...]."
    
    begin
      figures_array = WizardService.ask(prompt, "json_object")
      if figures_array.is_a?(Hash)
        figures_array = figures_array[figures_array.keys.first]
      end
      puts "Generated figures: #{figures_array}"
      
      created_figures = []
      figures_array.each do |figure_data|
        figure = @sport.figures.create!(
          title: figure_data["title"],
          summary: figure_data["summary"],
          birth_date: figure_data["birth_date"],
          death_date: figure_data["death_date"]
        )
        created_figures << figure
      end
      
      render json: {
        message: "Successfully generated #{created_figures.count} figures for #{@sport.title}",
        figures: created_figures.as_json(include: [:sport, :tags])
      }, status: :created
      
    rescue => e
      puts "Error: #{e.message}"
      render json: { 
        error: "Failed to generate figures", 
        details: e.message 
      }, status: :unprocessable_entity
    end
  end

  def generate_story
    prompt = "Write an engaging story about #{@sport.title}. Include interesting facts, history, and what makes this sport special. The story should be compelling and informative. Return as JSON with title and body fields: {\"title\": \"Story Title\", \"body\": \"Story content here...\"}"
    
    begin
      story_data = WizardService.ask(prompt, "json_object")
      puts "Generated story: #{story_data}"
      
      story = @sport.stories.create!(
        title: story_data["title"],
        body: story_data["body"]
      )
      
      render json: {
        message: "Successfully generated story for #{@sport.title}",
        story: story.as_json(include: [:storyable, :tags])
      }, status: :created
      
    rescue => e
      puts "Error: #{e.message}"
      render json: { 
        error: "Failed to generate story", 
        details: e.message 
      }, status: :unprocessable_entity
    end
  end

  def generate_sport_rules
    # Get existing rule titles to avoid duplicates
    existing_rules = @sport.sport_rules.pluck(:title)
    
    prompt = "Generate 5 important rules for #{@sport.title} that are not in this list: #{existing_rules.join(', ')}. For each rule, provide: title, summary, and detailed body. Return as JSON flat array with objects like this exactly unnested => [{\"title\": \"Rule Title\", \"summary\": \"Brief summary\", \"body\": \"Detailed rule description\"}, ...]."
    
    begin
      rules_array = WizardService.ask(prompt, "json_object")
      puts "Generated sport rules: #{rules_array}"
      if rules_array.is_a?(Hash)
        rules_array = rules_array[rules_array.keys.first]
      end
      
      created_rules = []
      rules_array.each do |rule_data|
        rule = @sport.sport_rules.create!(
          title: rule_data["title"],
          summary: rule_data["summary"],
          body: rule_data["body"]
        )
        created_rules << rule
      end
      
      render json: {
        message: "Successfully generated #{created_rules.count} sport rules for #{@sport.title}",
        sport_rules: created_rules.as_json(include: [:sport, :tags])
      }, status: :created
      
    rescue => e
      puts "Error: #{e.message}"
      render json: { 
        error: "Failed to generate sport rules", 
        details: e.message 
      }, status: :unprocessable_entity
    end
  end

  def generate_events
    prompt = "Today is June 20th 2025, what is the next major #{@sport.title} match? Give me {title:String, abbreviated_display_title: String, date:date}. Return as JSON object exactly like this: {\"title\": \"Full Event Title\", \"abbreviated_display_title\": \"Short Title\", \"date\": \"YYYY-MM-DD\"}."
    
    begin
      event_data = WizardService.ask(prompt, "json_object")
      puts "Generated event data: #{event_data}"
      
      if event_data.is_a?(Hash)
        event_data = event_data[event_data.keys.first] if event_data.keys.length == 1
      end
      
      event = @sport.events.create!(
        title: event_data["abbreviated_display_title"],
        date: event_data["date"]
      )
      
      render json: {
        message: "Successfully generated event for #{@sport.title}",
        event: event.as_json(include: [:eventable, :tags])
      }, status: :created
      
    rescue => e
      puts "Error: #{e.message}"
      render json: { 
        error: "Failed to generate event", 
        details: e.message 
      }, status: :unprocessable_entity
    end
  end

  private

  def set_sport
    @sport = Sport.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Sport not found' }, status: :not_found
  end

  def sport_params
    params.require(:sport).permit(:title, :sport_id, :position)
  end
end
