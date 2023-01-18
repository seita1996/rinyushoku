class Schedule < ApplicationRecord
  belongs_to :meal

  def self.recalculate(day, start_date)
    return false if day.empty? || start_date.empty?

    start_date = Date.parse(start_date)

    # テーブルの更新箇所以降のデータを全削除
    Schedule.includes(:meal).where(meals: { day: day.. }).destroy_all

    current_date = start_date - 1 # ループに入ってすぐ+1するため-1しておく
    Meal.where(day: day..).each do |meal|
      # 2回食以降は同日
      current_date += 1 if meal.ordinal_number == 1
      current_date = save_repeat_schedule(meal, current_date)
      schedule = Schedule.new(date: current_date, has_debut_food: meal.has_debut_food, meal_id: meal.id)

      # TODO: bulk update
      schedule.save
    end
    true
  end

  def self.save_repeat_schedule(meal, current_date)
    # 初めて食べる食材があり、当日が日曜または祝日またはカスタム休日ならば
    # 前日のScheduleを複製したあと日付をインクリメント（休日以外の日になるまで繰り返す）
    while meal.has_debut_food && (current_date.wday.zero? || HolidayJp.holiday?(current_date) || CustomHoliday.include?(current_date))
      Schedule.where(date: current_date - 1).each do |schedule|
        dup_schedule = schedule.dup
        dup_schedule.date = current_date

        # TODO: bulk update
        dup_schedule.save
      end
      current_date += 1
    end
    current_date
  end

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
