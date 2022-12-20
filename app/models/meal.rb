class Meal < ApplicationRecord
  has_many :meal_foods
  has_many :foods, :through => :meal_foods

  def self.import(file)
    # テーブルのデータを全削除
    MealFood.destroy_all
    Food.destroy_all
    Meal.destroy_all

    # CSVヘッダのday以外のセルをfoodsテーブルへインポート
    food_name_arr = CSV.read(file.path)[0].drop(1)
    # foods = food_name_arr.map { |food| JSON.parse("{\"name\": \"#{food}\"}") }
    foods = food_name_arr.map { |food| {name: food} }
    Food.insert_all(foods)

    # CSVのbodyをmeal_foodsテーブルへインポート
    meals = []
    before_row_day = -1
    ordinal_number = 1
    CSV.foreach(file.path, headers: true) do |row|
      if before_row_day == row['day'].to_i
        # dayの値が前の行と同じである場合（2回食、3回食がある日）
        ordinal_number += 1
      else
        # dayの値が前の行と異なる場合（1回食だけの日）
        ordinal_number = 1
      end
      meal = {day: row['day'], ordinal_number: ordinal_number}
      meals << meal
      before_row_day = row['day'].to_i
    end
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
      end
      eaten_foods_at_this_meal = row.select { |key, value| key != 'day' && value != nil }
      eaten_foods_at_this_meal.each do |food|
        meal_food = {food_id: Food.find_by(name: food[0]).id, meal_id: Meal.where(day: row['day'].to_i)[ordinal_number - 1].id, amount: food[1], debut: false}
        meal_foods << meal_food
      end
      before_row_day = row['day'].to_i
    end
    MealFood.insert_all(meal_foods)
  end

  # TODO: Modelの外へ
  # TODO: 発行するクエリを最小限に
  # スキップされた日の食事を前日の繰り返しにする
  def self.filled_meals(date_from, date_to)
    meals = Meal.includes(:foods).where(date: [date_from..date_to])
    target_dates = (Date.parse(date_from.to_s)..Date.parse(date_to.to_s)).to_a.map { |date| date.to_s }
    scheduled_dates = meals.map { |meal| meal.date.to_s }.uniq
    missing_pieces = target_dates - scheduled_dates
    result = []
    target_dates.each do |date|
      if missing_pieces.exclude?(date)
        # スキップされていない日：そのままresultへ挿入
        meals.where(date: date).each do |record|
          result << record
        end
      else
        # スキップされている日：日付を遡り、直近のスケジュールの日付を変更したものをresultへ挿入
        date_minus = 1
        before_date_meals = Meal.includes(:foods).where(date: (Date.parse(date) - date_minus))
        while before_date_meals.empty?
          date_minus += 1
          before_date_meals = Meal.includes(:foods).where(date: (Date.parse(date) - date_minus))
        end
        before_date_meals.each do |record|
          record.date = date
          result << record
        end
      end
    end
    result
  end

  def self.update_date(start_date)
    if start_date.empty?
      start_date = Date.today
    else
      start_date = Date.parse(start_date)
    end
    current_date = start_date - 1 # ループに入ってすぐ+1するため-1しておく
    Meal.all.each do |meal|
      # 2回食以降は同日
      current_date += 1 if meal.ordinal_number == 1

      # 初めて食べる食材があり、当日が日曜または祝日またはカスタム休日ならば日付をインクリメント（休日以外の日になるまで繰り返す）
      while meal.has_debut_food && (current_date.wday == 0 || HolidayJp.holiday?(current_date) || CustomHoliday.include?(current_date)) do
        current_date += 1
      end
      meal.date = current_date

      # TODO: bulk update
      meal.save
    end
  end

  def has_debut_food
    self.meal_foods.inject(false) { |result, mf| result || mf.debut }
  end
end
