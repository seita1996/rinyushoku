module SchedulesHelper
  def card_classes(schedule)
    return 'shadow-lg border rounded px-6 py-4 mb-2 bg-red-50' if schedule.has_debut_food

    'shadow-lg border rounded px-6 py-4 mb-2'
  end

  JAPANESE_WDAY = %w[日 月 火 水 木 金 土].freeze

  def view_date(date)
    date.strftime("%Y年%m月%d日（#{JAPANESE_WDAY[date.wday]}）")
  end
end
