class RemoveDateFromMeals < ActiveRecord::Migration[7.0]
  def change
    remove_column :meals, :date
  end
end
