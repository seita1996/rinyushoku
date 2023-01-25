class ImportMealTemplate
  include Interactor

  def call
    check_file_format(context.file_path)
    check_file_data(context.file_path)
    cleanup_template_and_schedule
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

  def cleanup_template_and_schedule
    Schedule.delete_all
    MealFood.delete_all
    Food.delete_all
    Meal.delete_all
  end

  def import(file_path)
    # CSVヘッダのday以外のセルをfoodsテーブルへインポート
    insert_foods(file_path)

    # CSVのbodyをmeal_foodsテーブルへインポート
    insert_meals(file_path)

    # CSVのbodyをmeal_foodsテーブルへインポート
    insert_meal_foods(file_path)
  end

  def insert_foods(file_path)
    food_name_arr = CSV.read(file_path)[0].drop(1)
    foods = food_name_arr.map { |food| { name: food } }
    Food.insert_all(foods)
  end

  def insert_meals(file_path)
    meals = []
    before_row_day = -1
    ordinal_number = 1
    CSV.foreach(file_path, headers: true) do |row|
      ordinal_number = ordinal_number(ordinal_number, before_row_day, row['day'].to_i)
      meal = { day: row['day'], ordinal_number: }
      meals << meal
      before_row_day = row['day'].to_i
    end
    Meal.insert_all(meals)
  end

  def insert_meal_foods(file_path)
    meal_foods = []
    before_row_day = -1
    ordinal_number = 1
    CSV.foreach(file_path, headers: true) do |row|
      ordinal_number = ordinal_number(ordinal_number, before_row_day, row['day'].to_i)
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

  def ordinal_number(ordinal_number, before_row_day, row_day)
    if before_row_day == row_day
      # dayの値が前の行と同じである場合（2回食、3回食がある日）
      ordinal_number += 1
    else
      # dayの値が前の行と異なる場合（1回食だけの日）
      ordinal_number = 1
    end
    ordinal_number
  end
end
