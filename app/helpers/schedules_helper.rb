module SchedulesHelper
  JAPANESE_WDAY = %w[日 月 火 水 木 金 土].freeze

  def view_date(date)
    date.strftime("%Y年%m月%d日（#{JAPANESE_WDAY[date.wday]}）")
  end
end
