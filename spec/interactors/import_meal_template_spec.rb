require 'spec_helper'

RSpec.describe ImportMealTemplate, type: :interactor do
  describe '.call' do
    context '規定に沿ったCSVファイルをインポートすると' do
      let(:file_path) { file_fixture('rinyushoku_success.csv') }
      def meals_name_amount(meal)
        "#{meal.meal_foods.map { |mf| "#{mf.food.name}#{mf.amount}" }.join('、')}"
      end
      it '登録された1日目1回食は「米粥1匙」である' do
        ImportMealTemplate.call(file_path: file_path)
        meal = Meal.where(day: 1, ordinal_number: 1).first
        expect(meals_name_amount(meal)).to eq('米粥1匙')
      end
      it '登録された2日目1回食は「米粥4匙、人参1匙」である' do
        ImportMealTemplate.call(file_path: file_path)
        meal = Meal.where(day: 2, ordinal_number: 1).first
        expect(meals_name_amount(meal)).to eq('米粥4匙、人参1匙')
      end
      it '登録された2日目2回食は「米粥4匙、南瓜1匙」である' do
        ImportMealTemplate.call(file_path: file_path)
        meal = Meal.where(day: 2, ordinal_number: 2).first
        expect(meals_name_amount(meal)).to eq('米粥4匙、南瓜1匙')
      end
      it '登録された3日目1回食は「米粥4匙、ほうれん草1匙」である' do
        ImportMealTemplate.call(file_path: file_path)
        meal = Meal.where(day: 3, ordinal_number: 1).first
        expect(meals_name_amount(meal)).to eq('米粥4匙、ほうれん草1匙')
      end
      it '登録された3日目2回食は「米粥5匙、人参2匙」である' do
        ImportMealTemplate.call(file_path: file_path)
        meal = Meal.where(day: 3, ordinal_number: 2).first
        expect(meals_name_amount(meal)).to eq('米粥5匙、人参2匙')
      end
      it '登録された3日目3回食は「米粥5匙、南瓜2匙、ブロッコリー1匙」である' do
        ImportMealTemplate.call(file_path: file_path)
        meal = Meal.where(day: 3, ordinal_number: 3).first
        expect(meals_name_amount(meal)).to eq('米粥5匙、南瓜2匙、ブロッコリー1匙')
      end
    end
    context 'Excelファイルをインポートすると' do
      let(:file_path) { file_fixture('rinyushoku_failure.xlsx') }
      it 'データの登録に失敗する' do
        expect(ImportMealTemplate.call(file_path: file_path).message).to eq('Only CSV file is allowed to be specified in file_path')
      end
    end
    context '空のCSVファイルをインポートすると' do
      let(:file_path) { file_fixture('rinyushoku_failure_empty.csv') }
      it 'データの登録に失敗する' do
        expect(ImportMealTemplate.call(file_path: file_path).message).to eq('Empty CSV cannot be imported')
      end
    end
    context '1列目(day)の値が数値ではないCSVファイルをインポートすると' do
      let(:file_path) { file_fixture('rinyushoku_failure_day_type.csv') }
      it 'データの登録に失敗する' do
        expect(ImportMealTemplate.call(file_path: file_path).message).to eq('The type of day is invalid')
      end
    end
    context '1行目の食材名が一部空であるCSVファイルをインポートすると' do
      let(:file_path) { file_fixture('rinyushoku_failure_insufficient_food.csv') }
      it 'データの登録に失敗する' do
        expect(ImportMealTemplate.call(file_path: file_path).message).to eq('There is missing data in the header')
      end
    end
    context '食材の量が記入されていない行のあるCSVファイルをインポートすると' do
      let(:file_path) { file_fixture('rinyushoku_failure_insufficient_amount.csv') }
      it 'データの登録に失敗する' do
        expect(ImportMealTemplate.call(file_path: file_path).message).to eq('There are lines where the amount of foods is not filled in')
      end
    end
  end
end
