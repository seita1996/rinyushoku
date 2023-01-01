require 'rails_helper'

RSpec.describe 'Model CustomHoliday', type: :model do
  describe 'validations' do
    context 'dateが空のとき' do
      let(:custom_holiday) { CustomHoliday.new(date: '', description: 'test') }
      it '登録に失敗する' do
        expect(custom_holiday.save).to eq(false)
      end
    end
    context 'dateが既に登録されているデータと重複しているとき' do
      let!(:pre_saved_custom_holiday) { FactoryBot.create(:custom_holiday, date: '2023-01-01', description: 'test') }
      let(:custom_holiday) { CustomHoliday.new(date: '2023-01-01', description: 'test') }
      it '登録に失敗する' do
        expect(custom_holiday.save).to eq(false)
      end
    end
    context 'dateが不正な日付のとき' do
      let(:custom_holiday) { CustomHoliday.new(date: '2023-13-32', description: 'test') }
      it '登録に失敗する' do
        expect(custom_holiday.save).to eq(false)
      end
    end
    context 'dateが正しい日付のとき' do
      let(:custom_holiday) { CustomHoliday.new(date: '2023-01-01', description: 'test') }
      it '登録に成功する' do
        expect(custom_holiday.save).to eq(true)
      end
    end
    context 'descriptionが50文字のとき' do
      let(:custom_holiday) { CustomHoliday.new(date: '2023-01-01', description: 'a' * 50) }
      it '登録に成功する' do
        expect(custom_holiday.save).to eq(true)
      end
    end
    context 'descriptionが51文字のとき' do
      let(:custom_holiday) { CustomHoliday.new(date: '2023-01-01', description: 'a' * 51) }
      it '登録に失敗する' do
        expect(custom_holiday.save).to eq(false)
      end
    end
  end
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
