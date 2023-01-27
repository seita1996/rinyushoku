class Schedule < ApplicationRecord
  belongs_to :meal

  def self.sum_foods(schedules)
    foods = {}
    schedules.each do |schedule|
      schedule.meal.meal_foods.each do |mf|
        foods[mf.food.name] = [] unless foods.key?(mf.food.name) # 食材がキーに存在しなければ空の配列を作成
        foods[mf.food.name] << mf.amount # 同じ食材を配列へ
      end
    end
    foods
  end
end
