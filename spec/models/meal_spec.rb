require 'rails_helper'

RSpec.describe 'Model Meal', type: :model do
  describe 'validations' do
    context 'dayが空のとき' do
      # let(:meal) { Meal.new(day: '') }
      let(:meal) { build(:meal, day: nil) }
      it '登録に失敗する' do
        expect(meal.save).to eq(false)
      end
    end
    context 'dayが1以上のとき' do
      let(:meal) { build(:meal, day: 1) }
      it '登録に成功する' do
        expect(meal.save).to eq(true)
      end
    end
    context 'dayが0以下のとき' do
      let(:meal) { build(:meal, day: 0) }
      it '登録に失敗する' do
        expect(meal.save).to eq(false)
      end
    end
    context 'dayが浮動小数のとき' do
      let(:meal) { build(:meal, day: 1.1) }
      it '登録に失敗する' do
        expect(meal.save).to eq(false)
      end
    end
    context 'ordinal_numberが空のとき' do
      let(:meal) { build(:meal, ordinal_number: nil) }
      it '登録に失敗する' do
        expect(meal.save).to eq(false)
      end
    end
    context 'ordinal_numberが1以上のとき' do
      let(:meal) { build(:meal, ordinal_number: 1) }
      it '登録に成功する' do
        expect(meal.save).to eq(true)
      end
    end
    context 'ordinal_numberが0以下のとき' do
      let(:meal) { build(:meal, ordinal_number: 0) }
      it '登録に失敗する' do
        expect(meal.save).to eq(false)
      end
    end
    context 'ordinal_numberが浮動小数のとき' do
      let(:meal) { build(:meal, ordinal_number: 1.1) }
      it '登録に失敗する' do
        expect(meal.save).to eq(false)
      end
    end
  end
  describe 'method debut_food?' do
    let(:file_path) { file_fixture('rinyushoku_success.csv') }
    before do
      # 事前にテンプレートデータをインポートしておく
      ImportMealTemplate.call(file_path: file_path)

      # インポートしたテンプレートからスケジュールを登録
      RecalculateSchedule.call(day: '1', start_date: '2023-01-16')
    end
    context '該当する食事に「初めて食べる食材」が1つでも含まれている場合' do
      it 'trueを返す' do
        day2_1st_meal = Meal.find_by(day: 2, ordinal_number: 1)
        expect(day2_1st_meal.debut_food?).to eq true
      end
    end
    context '該当する食事に「初めて食べる食材」が含まれない場合' do
      it 'falseを返す' do
        day3_2nd_meal = Meal.find_by(day: 3, ordinal_number: 2)
        expect(day3_2nd_meal.debut_food?).to eq false
      end
    end
  end
end
