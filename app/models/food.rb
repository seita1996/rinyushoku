class Food < ApplicationRecord
  has_many :meal_foods
  has_many :meals, :through => :meal_foods

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :name, length: { maximum: 50 }
end
