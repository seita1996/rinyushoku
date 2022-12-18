class MealFood < ApplicationRecord
  belongs_to :meal
  belongs_to :food

  def self.update_debut_flag
    debuted_food_ids = []
    MealFood.all.each do |meal_food|
      if debuted_food_ids.exclude?(meal_food.food_id)
        debuted_food_ids << meal_food.food_id
        meal_food.debut = true

        # TODO: bulk update
        meal_food.save
      end
    end
  end
end
