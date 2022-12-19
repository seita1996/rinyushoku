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

  def import
    Meal.import(params[:file])
    MealFood.update_debut_flag
    Meal.update_date(params[:start_date])
    redirect_to root_url
  end

  def sum_foods
    # TODO: ロジックをController外へ

    # 今日を含めた7日間のスケジュールを表示
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
    @meals = Meal.filled_meals(@from, @to)

    # 今日を含めて7日間の食材をリスト化
    @foods = {}
    @meals.each do |meal|
      meal.meal_foods.each do |mf|
        @foods[mf.food.name] = [] unless @foods.key?(mf.food.name) # 食材がキーに存在しなければ空の配列を作成
        @foods[mf.food.name] << mf.amount # 同じ食材を配列へ
      end
    end
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
end
