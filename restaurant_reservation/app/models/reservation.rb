class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :time_slot

  validates :number_of_people, presence: true, numericality: { greater_than: 0 }
  validate :time_slot_in_future
  validate :time_slot_availability
  validate :max_people_per_reservation

  private

  # Ensure reservation is at least 2 hours in advance
  def time_slot_in_future
    if time_slot
      reservation_time = time_slot.date.to_time + time_slot.start_time.seconds_since_midnight
      if reservation_time < Time.zone.now + 2.hours
        errors.add(:time_slot, "must be at least 2 hours in the future.")
      end
    end
  end

  # Check if the time slot has available tables
  def time_slot_availability
    if time_slot && time_slot.reservations.count >= time_slot.max_tables
      errors.add(:time_slot, "is fully booked.")
    end
  end

  # Validate the number of people per reservation
  def max_people_per_reservation
    if number_of_people > time_slot.max_people
      errors.add(:number_of_people, "exceeds the maximum allowed for this time slot!")
    end
  end
end
