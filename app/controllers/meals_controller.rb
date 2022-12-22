class MealsController < ApplicationController
  before_action :set_meal, only: %i[ show edit update destroy ]

  # GET /meals or /meals.json
  def index
    @meals = Meal.includes(:foods).all
  end

  # GET /meals/1 or /meals/1.json
  def show
  end

  # GET /meals/new
  def new
    @meal = Meal.new
  end

  # GET /meals/1/edit
  def edit
  end

  # POST /meals or /meals.json
  def create
    @meal = Meal.new(meal_params)

    respond_to do |format|
      if @meal.save
        format.html { redirect_to meal_url(@meal), notice: "Meal was successfully created." }
        format.json { render :show, status: :created, location: @meal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meals/1 or /meals/1.json
  def update
    respond_to do |format|
      if @meal.update(meal_params)
        format.html { redirect_to meal_url(@meal), notice: "Meal was successfully updated." }
        format.json { render :show, status: :ok, location: @meal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meals/1 or /meals/1.json
  def destroy
    @meal.destroy

    respond_to do |format|
      format.html { redirect_to meals_url, notice: "Meal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST /meals/import
  def import
    Meal.import(params[:file])
    MealFood.update_debut_flag
    Meal.update_date(params[:start_date])
    redirect_to root_url
  end

  # GET /meals/sum_foods
  def sum_foods
    set_date_range
    @meals = Meal.filled_meals(@from, @to)
    @foods = Meal.sum_foods(@meals)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meal
      @meal = Meal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def meal_params
      params.require(:meal).permit(:day, :ordinal_number, :date)
    end

    def set_date_range
      # デフォルト：今日を含めた7日間のスケジュールを表示
      @from =
        if params[:from].nil? || params[:from].empty?
          Date.today
        else
          Date.parse(params[:from])
        end
      @to =
        if params[:to].nil? || params[:to].empty?
          @from + 6
        else
          Date.parse(params[:to])
        end
    end
end
