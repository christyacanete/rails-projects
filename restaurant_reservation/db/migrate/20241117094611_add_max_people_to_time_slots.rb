class AddMaxPeopleToTimeSlots < ActiveRecord::Migration[8.0]
  def change
    add_column :time_slots, :max_people, :integer, default: 4, null: false
  end
end
