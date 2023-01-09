class AddReferencesToSchedules < ActiveRecord::Migration[7.0]
  def change
    add_reference :schedules, :meal, foreign_key: true
  end
end
