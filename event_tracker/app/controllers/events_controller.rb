class EventsController < ApplicationController
  
  # Show all events
  def index
    @events = Event.all
  end

  # Show the details of the event based on event ID
  def show
    @event = Event.find(params[:id])
  end

  # Create new form
  def new
    @event = Event.new
  end

  # Submit new form
  def create
    @event = Event.new(event_params)
    if(@event.save)
      flash[:success] = "Event was successfully created!"
      redirect_to @event
    else
      render 'new'
    end
  end

  private

    def event_params
      params.require(:event).permit(:name, :description, :date)
    end

end
