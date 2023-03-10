class CustomHoliday < ApplicationRecord
  validates :date, presence: true, uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 50 }
  def self.include?(date)
    return false if CustomHoliday.find_by(date:).nil?

    true
  end
end
