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
  describe 'def self.import' do
    context '規定に沿ったCSVファイルをインポートすると' do
      let(:file_path) { file_fixture('rinyushoku_success.csv') }
      def meals_name_amount(meal)
        "#{meal.meal_foods.map { |mf| "#{mf.food.name}#{mf.amount}" }.join('、')}"
      end
      it '登録された1日目1回食は「米粥1匙」である' do
        Meal.import(file_path)
        meal = Meal.where(day: 1, ordinal_number: 1).first
        expect(meals_name_amount(meal)).to eq('米粥1匙')
      end
      it '登録された2日目1回食は「米粥4匙、人参1匙」である' do
        Meal.import(file_path)
        meal = Meal.where(day: 2, ordinal_number: 1).first
        expect(meals_name_amount(meal)).to eq('米粥4匙、人参1匙')
      end
      it '登録された2日目2回食は「米粥4匙、南瓜1匙」である' do
        Meal.import(file_path)
        meal = Meal.where(day: 2, ordinal_number: 2).first
        expect(meals_name_amount(meal)).to eq('米粥4匙、南瓜1匙')
      end
      it '登録された3日目1回食は「米粥4匙、ほうれん草1匙」である' do
        Meal.import(file_path)
        meal = Meal.where(day: 3, ordinal_number: 1).first
        expect(meals_name_amount(meal)).to eq('米粥4匙、ほうれん草1匙')
      end
      it '登録された3日目2回食は「米粥5匙、人参2匙」である' do
        Meal.import(file_path)
        meal = Meal.where(day: 3, ordinal_number: 2).first
        expect(meals_name_amount(meal)).to eq('米粥5匙、人参2匙')
      end
      it '登録された3日目3回食は「米粥5匙、南瓜2匙、ブロッコリー1匙」である' do
        Meal.import(file_path)
        meal = Meal.where(day: 3, ordinal_number: 3).first
        expect(meals_name_amount(meal)).to eq('米粥5匙、南瓜2匙、ブロッコリー1匙')
      end
    end
  end
end
