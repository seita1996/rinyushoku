module Schedules
  class Recalculate
    def self.call(day, start_date)
      return false if day.empty? || start_date.empty?

      start_date = Date.parse(start_date)

      # テーブルの更新箇所以降のデータを全削除
      Schedule.includes(:meal).where(meals: { day: day.. }).destroy_all

      current_date = start_date - 1 # ループに入ってすぐ+1するため-1しておく
      schedules = []
      Meal.where(day: day..).each do |meal|
        # 2回食以降は同日
        current_date += 1 if meal.ordinal_number == 1
        repeat_result = save_repeat_schedule(meal, current_date, schedules)
        current_date = repeat_result[:current_date]
        schedules = repeat_result[:schedules]
        schedules << { date: current_date, has_debut_food: meal.has_debut_food, meal_id: meal.id }
      end
      Schedule.insert_all(schedules)
      true
    end

    def self.save_repeat_schedule(meal, current_date, schedules)
      # 初めて食べる食材があり、当日が日曜または祝日またはカスタム休日ならば
      # 前日のScheduleを複製したあと日付をインクリメント（休日以外の日になるまで繰り返す）
      while meal.has_debut_food && (current_date.wday.zero? || HolidayJp.holiday?(current_date) || CustomHoliday.include?(current_date))
        schedules.filter { |schedule| schedule[:date] == current_date - 1 }.each do |schedule|
          dup_schedule = schedule.dup
          dup_schedule[:date] = current_date
          schedules << dup_schedule
        end
        current_date += 1
      end
      { current_date:, schedules: }
    end
  end
end
