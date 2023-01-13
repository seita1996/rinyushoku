module Api
  module V1
    class SchedulesController < ApplicationController
      def index
        schedules = Schedule.includes(meal: :foods).where(date: [Date.today..(Date.today + 2)])
        meals = schedules.map do |schedule|
          { date: schedule.date, text: "#{schedule.meal.ordinal_number}回食(#{schedule.meal.meal_foods.map { |mf| "#{mf.food.name}#{mf.amount}" }.join(' ')})" }
        end
        respond_to do |format|
          format.json { render json: { title: '離乳食', meals: }, status: :ok }
        end
      end
    end
  end
end
