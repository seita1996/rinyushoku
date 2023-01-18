class AddColumnToSchedules < ActiveRecord::Migration[7.0]
  def change
    add_column :schedules, :has_debut_food, :boolean, :default => false
  end
end
