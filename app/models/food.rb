class Food < ApplicationRecord
  has_many :meals, :through => :meal_foods
end
