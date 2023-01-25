class MealFood < ApplicationRecord
  belongs_to :meal
  belongs_to :food

  validates :amount, presence: true, length: { maximum: 50 }
end
