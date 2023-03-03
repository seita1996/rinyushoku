require 'rails_helper'

RSpec.describe 'Model Meal', type: :model do
  describe 'method sum_foods' do
    context 'スケジュールがrinyushoku_success.csvをインポートしたときのものである場合' do
      let(:file_path) { file_fixture('rinyushoku_success.csv') }
      before do
        # 事前にテンプレートデータをインポートしておく
        ImportMealTemplate.call(file_path: file_path)

        # インポートしたテンプレートからスケジュールを登録
        RecalculateSchedule.call(day: '1', start_date: '2023-01-16')
      end
      it '集計結果は 米粥⇒1匙 4匙 4匙 4匙 5匙 5匙、人参⇒1匙 2匙、南瓜⇒1匙 2匙、ブロッコリー⇒1匙、ほうれん草⇒1匙' do
        sum_result = Schedule.sum_foods(Schedule.all)
        expect(sum_result['米粥']).to match_array(['1匙', '4匙', '4匙', '4匙', '5匙', '5匙'])
        expect(sum_result['人参']).to match_array(['1匙', '2匙'])
        expect(sum_result['南瓜']).to match_array(['1匙', '2匙'])
        expect(sum_result['ブロッコリー']).to match_array(['1匙'])
        expect(sum_result['ほうれん草']).to match_array(['1匙'])
      end
    end
  end
end
