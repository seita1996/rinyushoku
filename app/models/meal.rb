class Meal < ApplicationRecord
  has_many :foods, :through => :meal_foods

  def self.import(file)
    # CSVヘッダのday以外のセルをfoodsテーブルへインポート
    food_name_arr = CSV.read(file.path)[0].drop(1)
    # foods = food_name_arr.map { |food| JSON.parse("{\"name\": \"#{food}\"}") }
    foods = food_name_arr.map { |food| {name: food} }
    Food.destroy_all
    Food.insert_all(foods)

    # CSVのbodyをmeal_foodsテーブルへインポート
    meals = []
    current_day = Date.today - 1 # ループに入ってすぐ+1するため-1しておく。TODO: 引数の日付に置き換え
    before_row_day = -1
    ordinal_number = 1
    CSV.foreach(file.path, headers: true) do |row|
      if before_row_day == row['day'].to_i
        # dayの値が前の行と同じである場合（2回食、3回食がある日）
        ordinal_number += 1
      else
        # dayの値が前の行と異なる場合（1回食だけの日）
        ordinal_number = 1
        current_day += 1
      end
      meal = {day: row['day'], ordinal_number: ordinal_number, date: current_day}
      meals << meal
      before_row_day = row['day'].to_i
    end
    Meal.destroy_all
    Meal.insert_all(meals)

    # CSVのbodyをmeal_foodsテーブルへインポート
    meal_foods = []
    before_row_day = -1
    ordinal_number = 1
    CSV.foreach(file.path, headers: true) do |row|
      if before_row_day == row['day'].to_i
        # dayの値が前の行と同じである場合（2回食、3回食がある日）
        ordinal_number += 1
      else
        # dayの値が前の行と異なる場合（1回食だけの日）
        ordinal_number = 1
        current_day += 1
      end
      eaten_foods_at_this_meal = row.select { |key, value| key != 'day' && value != nil }
      eaten_foods_at_this_meal.each do |food|
        meal_food = {food_id: Food.find_by(name: food[0]).id, meal_id: Meal.where(day: row['day'].to_i)[ordinal_number - 1].id, amount: food[1], debut: false}
        meal_foods << meal_food
      end
      before_row_day = row['day'].to_i
    end
    logger.debug(meal_foods)
    MealFood.destroy_all
    MealFood.insert_all(meal_foods)
  end
end
