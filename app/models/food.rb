class Food < ApplicationRecord
  has_many :meal_foods
  has_many :meals, through: :meal_foods

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
end
