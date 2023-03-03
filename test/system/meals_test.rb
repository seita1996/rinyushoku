require 'application_system_test_case'

class MealsTest < ApplicationSystemTestCase
  setup do
    @meal = meals(:one)
  end

  test 'visiting the index' do
    visit meals_url
    assert_selector 'h1', text: 'Meals'
  end

  test 'should create meal' do
    visit meals_url
    click_on 'New meal'

    fill_in 'Date', with: @meal.date
    fill_in 'Day', with: @meal.day
    fill_in 'Ordinal number', with: @meal.ordinal_number
    click_on 'Create Meal'

    assert_text 'Meal was successfully created'
    click_on 'Back'
  end

  test 'should update Meal' do
    visit meal_url(@meal)
    click_on 'Edit this meal', match: :first

    fill_in 'Date', with: @meal.date
    fill_in 'Day', with: @meal.day
    fill_in 'Ordinal number', with: @meal.ordinal_number
    click_on 'Update Meal'

    assert_text 'Meal was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Meal' do
    visit meal_url(@meal)
    click_on 'Destroy this meal', match: :first

    assert_text 'Meal was successfully destroyed'
  end
end
