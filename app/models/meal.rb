class Meal < ApplicationRecord
  has_many :foods, :through => :meal_foods
end
