require 'rails_helper'

RSpec.describe 'Model Food', type: :model do
  describe 'validations' do
    context 'nameが空のとき' do
      let(:food) { Food.new(name: '') }
      it '登録に失敗する' do
        expect(food.save).to eq(false)
      end
    end
    context 'nameが既に登録されているデータと重複しているとき' do
      let!(:pre_saved_food) { FactoryBot.create(:food, name: 'hoge') }
      let(:food) { Food.new(name: 'hoge') }
      it '登録に失敗する' do
        expect(food.save).to eq(false)
      end
    end
    context 'nameが50文字のとき' do
      let(:food) { Food.new(name: 'a' * 50) }
      it '登録に成功する' do
        expect(food.save).to eq(true)
      end
    end
    context 'nameが51文字のとき' do
      let(:food) { Food.new(name: 'a' * 51) }
      it '登録に失敗する' do
        expect(food.save).to eq(false)
      end
    end
  end
end
