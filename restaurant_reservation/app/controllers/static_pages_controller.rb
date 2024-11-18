class StaticPagesController < ApplicationController
  def home
    @time_slots = TimeSlot.order(:date, :start_time)
  end

  def logout
    # This action renders the logout.html.erb template
  end
end