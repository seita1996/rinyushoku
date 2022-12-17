class CreateMealFoods < ActiveRecord::Migration[7.0]
  def change
    create_table :meal_foods do |t|
      t.references :meal, null: false, foreign_key: true
      t.references :food, null: false, foreign_key: true
      t.string :amount
      t.boolean :debut

      t.timestamps
    end
  end
end
