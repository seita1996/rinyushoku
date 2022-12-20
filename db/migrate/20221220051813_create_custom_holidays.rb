class CreateCustomHolidays < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_holidays do |t|
      t.date :date
      t.string :description

      t.timestamps
    end
  end
end
