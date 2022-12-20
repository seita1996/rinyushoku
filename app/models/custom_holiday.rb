class CustomHoliday < ApplicationRecord
  def self.include?(date)
    return false if CustomHoliday.find_by(date: date).nil?
    true
  end
end
