class Meal < ApplicationRecord
  has_many :schedules
  has_many :meal_foods
  has_many :foods, :through => :meal_foods

  validates :day, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :ordinal_number, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  def has_debut_food
    self.meal_foods.inject(false) { |result, mf| result || mf.debut }
  end
end
