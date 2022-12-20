require "test_helper"

class CustomHolidaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @custom_holiday = custom_holidays(:one)
  end

  test "should get index" do
    get custom_holidays_url
    assert_response :success
  end

  test "should get new" do
    get new_custom_holiday_url
    assert_response :success
  end

  test "should create custom_holiday" do
    assert_difference("CustomHoliday.count") do
      post custom_holidays_url, params: { custom_holiday: { date: @custom_holiday.date, description: @custom_holiday.description } }
    end

    assert_redirected_to custom_holiday_url(CustomHoliday.last)
  end

  test "should show custom_holiday" do
    get custom_holiday_url(@custom_holiday)
    assert_response :success
  end

  test "should get edit" do
    get edit_custom_holiday_url(@custom_holiday)
    assert_response :success
  end

  test "should update custom_holiday" do
    patch custom_holiday_url(@custom_holiday), params: { custom_holiday: { date: @custom_holiday.date, description: @custom_holiday.description } }
    assert_redirected_to custom_holiday_url(@custom_holiday)
  end

  test "should destroy custom_holiday" do
    assert_difference("CustomHoliday.count", -1) do
      delete custom_holiday_url(@custom_holiday)
    end

    assert_redirected_to custom_holidays_url
  end
end
