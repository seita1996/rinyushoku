require 'rails_helper'

RSpec.describe SchedulesHelper, type: :helper do
  describe 'def view_date(date)' do
    it { expect(helper.view_date(Date.parse('2023-01-01'))).to eq('2023年01月01日（日）') }
    it { expect(helper.view_date(Date.parse('2023-01-02'))).to eq('2023年01月02日（月）') }
    it { expect(helper.view_date(Date.parse('2023-01-03'))).to eq('2023年01月03日（火）') }
    it { expect(helper.view_date(Date.parse('2023-01-04'))).to eq('2023年01月04日（水）') }
    it { expect(helper.view_date(Date.parse('2023-01-05'))).to eq('2023年01月05日（木）') }
    it { expect(helper.view_date(Date.parse('2023-01-06'))).to eq('2023年01月06日（金）') }
    it { expect(helper.view_date(Date.parse('2023-01-07'))).to eq('2023年01月07日（土）') }
  end
end
