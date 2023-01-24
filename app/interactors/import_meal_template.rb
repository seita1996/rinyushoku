class ImportMealTemplate
  include Interactor

  def call
    check_file_format(context.file_path)
    check_file_data(context.file_path)
    delete_schedule_meal_food_data
    import(context.file_path)
  rescue StandardError => e
    context.fail!(message: e.message)
  end

  # def rollback
  # end

  private

  def check_file_format(file_path)
    raise StandardError, 'Only CSV file is allowed to be specified in file_path' if File.extname(file_path) != '.csv'
    raise StandardError, 'Empty CSV cannot be imported' if CSV.read(file_path)[0].nil?
    raise StandardError, 'The type of day is invalid' unless CSV.read(file_path).transpose[0].drop(1).filter { |cell| !number?(cell) }.empty?
  end

  def check_file_data(file_path)
    raise StandardError, 'There is missing data in the header' unless CSV.read(file_path)[0].filter(&:nil?).empty?
    raise StandardError, 'There are lines where the amount of foods is not filled in' if CSV.read(file_path).drop(1).any? { |row| row.drop(1).all?(&:nil?) }
  end

  def delete_schedule_meal_food_data
    # テーブルのデータを全削除
    Schedule.destroy_all
    MealFood.destroy_all
    Food.destroy_all
    Meal.destroy_all
  end

  def import(file_path)
    # CSVヘッダのday以外のセルをfoodsテーブルへインポート
    food_name_arr = CSV.read(file_path)[0].drop(1)
    # foods = food_name_arr.map { |food| JSON.parse("{\"name\": \"#{food}\"}") }
    foods = food_name_arr.map { |food| { name: food } }
    Food.insert_all(foods)

    # CSVのbodyをmeal_foodsテーブルへインポート
    meals = []
    before_row_day = -1
    ordinal_number = 1
    CSV.foreach(file_path, headers: true) do |row|
      if before_row_day == row['day'].to_i
        # dayの値が前の行と同じである場合（2回食、3回食がある日）
        ordinal_number += 1
      else
        # dayの値が前の行と異なる場合（1回食だけの日）
        ordinal_number = 1
      end
      meal = { day: row['day'], ordinal_number: }
      meals << meal
      before_row_day = row['day'].to_i
    end
    Meal.insert_all(meals)

    # CSVのbodyをmeal_foodsテーブルへインポート
    meal_foods = []
    before_row_day = -1
    ordinal_number = 1
    CSV.foreach(file_path, headers: true) do |row|
      if before_row_day == row['day'].to_i
        # dayの値が前の行と同じである場合（2回食、3回食がある日）
        ordinal_number += 1
      else
        # dayの値が前の行と異なる場合（1回食だけの日）
        ordinal_number = 1
      end
      eaten_foods_at_this_meal = row.select { |key, value| key != 'day' && !value.nil? }
      eaten_foods_at_this_meal.each do |food|
        meal_food = { food_id: Food.find_by(name: food[0]).id, meal_id: Meal.where(day: row['day'].to_i)[ordinal_number - 1].id, amount: food[1], debut: false }
        meal_foods << meal_food
      end
      before_row_day = row['day'].to_i
    end
    MealFood.insert_all(meal_foods)
  end

  def number?(str)
    # 文字列が数字だけで構成されていれば true を返す
    # 文字列の先頭(\A)から末尾(\z)までが「0」から「9」の文字か
    (str =~ /\A[0-9]+\z/) != nil
  end
end
