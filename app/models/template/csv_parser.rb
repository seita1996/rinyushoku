module Template
  class CsvParser
    attr_reader :file_path
    attr_accessor :foods, :meals, :meal_foods

    CsvFood = Struct.new(:id, :name, keyword_init: true)
    CsvMeal = Struct.new(:id, :day, :ordinal_number, keyword_init: true)
    CsvMealFood = Struct.new(:food_id, :meal_id, :amount, :debut, keyword_init: true)

    def initialize(file_path)
      @file_path = file_path
      @foods = parse_foods
      @meals = parse_meals
      @meal_foods = parse_meal_foods
    end

    def foods_h
      foods.map(&:to_h)
    end

    def meals_h
      meals.map(&:to_h)
    end

    def meal_foods_h
      meal_foods.map(&:to_h)
    end

    private

    def ordinal_number(last_record, row_day)
      # 最初の行 または dayの値が前の行と異なる場合（1回食だけの日）
      return 1 if last_record.nil? || last_record.day != row_day

      # dayの値が前の行と同じである場合（2回食、3回食がある日）
      last_record.ordinal_number + 1
    end

    def parse_foods
      food_names = CSV.read(file_path)[0].drop(1)
      food_names.map.with_index(1) { |name, idx| CsvFood.new(id: idx, name:) }
    end

    def parse_meals
      result = []
      CSV.foreach(file_path, headers: true).with_index(1) do |row, idx|
        day = row['day'].to_i
        result << CsvMeal.new(id: idx, day:, ordinal_number: ordinal_number(result.last, day))
      end
      result
    end

    def parse_meal_foods
      debuted_food_ids = []
      is_debut = lambda do |food_id|
        if debuted_food_ids.exclude?(food_id)
          debuted_food_ids << food_id
          return true
        end
        return false
      end

      result = []
      CSV.foreach(file_path, headers: true).with_index(1) do |row, idx|
        eaten_foods_at_this_meal = row.filter { |key, value| key != 'day' && !value.nil? }
                                      .map { |food| { name: food[0], amount: food[1] } }
        eaten_foods_at_this_meal.each do |food|
          food_id = foods.filter { |f| f.name == food[:name] }.first.id
          result << CsvMealFood.new(food_id:, meal_id: idx, amount: food[:amount], debut: is_debut.call(food_id))
        end
      end
      result
    end
  end
end
