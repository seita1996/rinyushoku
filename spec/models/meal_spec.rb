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
end
