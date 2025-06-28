class EventsController < BaseController
  before_action :set_event, only: [:show, :update, :destroy, :add_event]
  before_action :set_sport, only: [:index]
  
  def index
    if @sport
      @events = @sport.events.includes(:eventable, :tags).ordered
    else
      @events = Event.includes(:eventable, :tags).ordered
    end
    render json: @events
  end

  def show
    render json: @event.as_json(include: [:eventable, :tags])
  end

  def create
    @event = Event.new(event_params)
    
    if @event.save
      render json: @event.as_json(include: [:eventable, :tags]), status: :created
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: @event.as_json(include: [:eventable, :tags])
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    head :no_content
  end

  def generate_story
    eventable_name = @event.eventable.respond_to?(:title) ? @event.eventable.title : @event.eventable.class.name
    prompt = "Write an engaging story about the event '#{@event.title}' involving #{eventable_name}. Include the significance of this event, what happened, and its impact. The story should be compelling and informative. Return as JSON with title and body fields: {\"title\": \"Story Title\", \"body\": \"Story content here...\"}"
    
    begin
      story_data = WizardService.ask(prompt, "json_object")
      puts "Generated story: #{story_data}"
      
      story = @event.stories.create!(
        title: story_data["title"],
        body: story_data["body"]
      )
      
      render json: {
        message: "Successfully generated story for event '#{@event.title}'",
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

  def add_event
    # Create a new event that belongs to the current event
    new_event = Event.new(event_params.merge(eventable: @event))
    
    if new_event.save
      render json: {
        message: "Successfully added event '#{new_event.title}' to '#{@event.title}'",
        event: new_event.as_json(include: [:eventable, :tags])
      }, status: :created
    else
      render json: { 
        errors: new_event.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  private

  def set_sport
    @sport = Sport.find(params[:sport_id])
  end

  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Event not found' }, status: :not_found
  end

  def event_params
    params.require(:event).permit(:title, :start_date, :end_date, :eventable_type, :eventable_id)
  end
end
