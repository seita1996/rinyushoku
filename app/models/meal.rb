class Meal < ApplicationRecord
  has_many :foods, :through => :meal_foods

  def self.import(file)
    logger.debug("import!!!!!!!!!")
    CSV.foreach(file.path, headers: true) do |row|
      logger.debug("day: #{row['day']}")
    end
  end
end
