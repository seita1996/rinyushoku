require 'rails_helper'

RSpec.describe 'Schedules::Recalculate', type: :poro do
  describe 'recalculate' do
    let(:file_path) { file_fixture('rinyushoku_success.csv') }
    before do
      # 事前にテンプレートデータをインポートしておく
      ImportMealTemplate.call(file_path: file_path)
    end
    context '日曜日・祝日・カスタム休日に初めて食べる食材があるとき、該当日は直前のスケジュールの繰り返しとなる' do
      before do
        # 2023/1/7は土曜日、2023/1/8は日曜日、2023/1/9は月曜日（祝日）、2023/1/10は火曜日（カスタム休日）、2023/1/11は水曜日
        FactoryBot.create(:custom_holiday, date: '2023-01-10')
        Schedules::Recalculate.call('1', '2023-01-07')
      end
      it '2023/1/7はテンプレートのday1である' do
        expect(Schedule.includes(:meal).where(date: '2023-01-07').first.meal.day).to eq(1)
      end
      it '2023/1/8はテンプレートのday1である' do
        expect(Schedule.includes(:meal).where(date: '2023-01-08').first.meal.day).to eq(1)
      end
      it '2023/1/9はテンプレートのday1である' do
        expect(Schedule.includes(:meal).where(date: '2023-01-09').first.meal.day).to eq(1)
      end
      it '2023/1/10はテンプレートのday1である' do
        expect(Schedule.includes(:meal).where(date: '2023-01-10').first.meal.day).to eq(1)
      end
      it '2023/1/11はテンプレートのday2である' do
        expect(Schedule.includes(:meal).where(date: '2023-01-11').first.meal.day).to eq(2)
      end
    end
  end
end
