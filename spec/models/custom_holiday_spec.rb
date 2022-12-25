require 'rails_helper'

RSpec.describe 'Model CustomHoliday', type: :model do
  describe 'method include?' do
    let!(:custom_holiday1) { FactoryBot.create(:custom_holiday, date: Date.today - 1) }
    let!(:custom_holiday2) { FactoryBot.create(:custom_holiday, date: Date.today - 2) }

    context '引数の日付がcustom_holidayに登録されているとき' do
      it 'trueを返す' do
        expect(CustomHoliday.include?(custom_holiday1.date)).to eq true
      end
    end

    context '引数の日付がcustom_holidayに登録されていないとき' do
      it 'falseを返す' do
        expect(CustomHoliday.include?(Date.today.to_s)).to eq false
      end
    end
  end
end
