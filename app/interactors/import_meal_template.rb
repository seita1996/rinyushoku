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
    raise StandardError, 'The type of day is invalid' unless CSV.read(file_path).transpose[0].drop(1).filter do |cell|
                                                               !number?(cell)
                                                             end.empty?
  end

  def check_file_data(file_path)
    raise StandardError, 'There is missing data in the header' unless CSV.read(file_path)[0].filter(&:nil?).empty?

    if CSV.read(file_path).drop(1).any? do |row|
         row.drop(1).all?(&:nil?)
       end
      raise StandardError,
            'There are lines where the amount of foods is not filled in'
    end
  end

  def cleanup_template_and_schedule
    Schedule.delete_all
    MealFood.delete_all
    Food.delete_all
    Meal.delete_all
  end

  def import(file_path)
    csv_parser = Template::CsvParser.new(file_path)

    # CSVヘッダのday以外のセルをfoodsテーブルへインポート
    foods = csv_parser.foods_h
    Food.insert_all(foods)

    # CSVのbodyをmeal_foodsテーブルへインポート
    meals = csv_parser.meals_h
    Meal.insert_all(meals)

    # CSVのbodyをmeal_foodsテーブルへインポート
    meal_foods = csv_parser.meal_foods_h
    MealFood.insert_all(meal_foods)
  end

  def number?(str)
    # 文字列が数字だけで構成されていれば true を返す
    # 文字列の先頭(\A)から末尾(\z)までが「0」から「9」の文字か
    (str =~ /\A[0-9]+\z/) != nil
  end
end
