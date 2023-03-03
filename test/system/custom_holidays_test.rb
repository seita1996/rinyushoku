require 'application_system_test_case'

class CustomHolidaysTest < ApplicationSystemTestCase
  setup do
    @custom_holiday = custom_holidays(:one)
  end

  test 'visiting the index' do
    visit custom_holidays_url
    assert_selector 'h1', text: 'Custom holidays'
  end

  test 'should create custom holiday' do
    visit custom_holidays_url
    click_on 'New custom holiday'

    fill_in 'Date', with: @custom_holiday.date
    fill_in 'Description', with: @custom_holiday.description
    click_on 'Create Custom holiday'

    assert_text 'Custom holiday was successfully created'
    click_on 'Back'
  end

  test 'should update Custom holiday' do
    visit custom_holiday_url(@custom_holiday)
    click_on 'Edit this custom holiday', match: :first

    fill_in 'Date', with: @custom_holiday.date
    fill_in 'Description', with: @custom_holiday.description
    click_on 'Update Custom holiday'

    assert_text 'Custom holiday was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Custom holiday' do
    visit custom_holiday_url(@custom_holiday)
    click_on 'Destroy this custom holiday', match: :first

    assert_text 'Custom holiday was successfully destroyed'
  end
end
