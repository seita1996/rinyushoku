require 'rails_helper'

RSpec.describe 'Model MealFood', type: :model do
  describe 'validations' do
    let(:meal) { create(:meal) }
    let(:food) { create(:food) }
    context 'amountが空のとき' do
      let(:meal_food) { MealFood.new(amount: '', meal_id: meal.id, food_id: food.id) }
      it '登録に失敗する' do
        expect(meal_food.save).to eq(false)
      end
    end
    context 'amountが50文字のとき' do
      let(:meal_food) { MealFood.new(amount: 'a' * 50, meal_id: meal.id, food_id: food.id) }
      it '登録に成功する' do
        expect(meal_food.save).to eq(true)
      end
    end
    context 'amountが51文字のとき' do
      let(:meal_food) { MealFood.new(amount: 'a' * 51, meal_id: meal.id, food_id: food.id) }
      it '登録に失敗する' do
        expect(meal_food.save).to eq(false)
      end
    end
  end
end
