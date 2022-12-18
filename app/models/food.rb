class Food < ApplicationRecord
  has_many :meal_foods
  has_many :meals, :through => :meal_foods
end
