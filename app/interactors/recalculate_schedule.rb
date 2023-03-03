class RecalculateSchedule
  include Interactor

  ScheduleRecord = Struct.new(:date, :has_debut_food, :meal_id, keyword_init: true)

  def call
    day = context.day
    start_date = context.start_date
    raise StandardError, 'Invalid Arguments' if day.empty? || start_date.empty?

    start_date = Date.parse(start_date)
    delete_schedules(day)
    schedules = create_schedules(day, start_date)
    Schedule.insert_all(schedules)
  end

  private

  def create_schedules(day, start_date)
    schedules = []
    current_date = start_date - 1 # ループに入ってすぐ+1するため-1しておく
    Meal.where(day: day..).each do |meal|
      # 2回食以降は同日
      current_date += 1 if meal.ordinal_number == 1

      # 初めて食べる食材があり、当日が日曜または祝日またはカスタム休日ならば
      # 前日のScheduleを複製したあと日付をインクリメント（休日以外の日になるまで繰り返す）
      while meal.debut_food? && holiday?(current_date)
        dup_yesterday_schedules(current_date, schedules).each do |dup_schedule|
          schedules << dup_schedule
        end
        current_date += 1
      end
      schedules << ScheduleRecord.new(date: current_date, has_debut_food: meal.debut_food?, meal_id: meal.id)
    end
    schedules.map(&:to_h)
  end

  def delete_schedules(first_day_to_delete)
    # テーブルの更新箇所以降のデータを全削除
    Schedule.includes(:meal).where(meals: { day: first_day_to_delete.. }).destroy_all
  end

  def holiday?(current_date)
    current_date.wday.zero? || HolidayJp.holiday?(current_date) || CustomHoliday.include?(current_date)
  end

  def dup_yesterday_schedules(current_date, schedules)
    result = []
    schedules.filter { |schedule| schedule.date == current_date - 1 }.each do |schedule|
      dup_schedule = schedule.dup
      dup_schedule.date = current_date
      result << dup_schedule
    end
    result
  end
end
