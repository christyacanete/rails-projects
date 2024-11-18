class TimeSlot < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :max_people, presence: true, numericality: { greater_than: 0 }

  def display_text
    "#{date.strftime('%B %d, %Y')} - #{start_time.strftime('%I:%M %p')} to #{end_time.strftime('%I:%M %p')}"
  end

  # Fetch available time slots (time slots with tables available)
  def self.available_slots
    where("date >= ?", Date.today).order(:date, :start_time)
  end

  # Format time slot display for dropdowns
  def display_time
    "#{date.strftime('%b %d, %Y')} (#{start_time.strftime('%I:%M %p')} - #{end_time.strftime('%I:%M %p')})"
  end
end
