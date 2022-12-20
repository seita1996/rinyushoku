class CustomHolidaysController < ApplicationController
  before_action :set_custom_holiday, only: %i[ show edit update destroy ]

  # GET /custom_holidays or /custom_holidays.json
  def index
    @custom_holidays = CustomHoliday.all
  end

  # GET /custom_holidays/1 or /custom_holidays/1.json
  def show
  end

  # GET /custom_holidays/new
  def new
    @custom_holiday = CustomHoliday.new
  end

  # GET /custom_holidays/1/edit
  def edit
  end

  # POST /custom_holidays or /custom_holidays.json
  def create
    @custom_holiday = CustomHoliday.new(custom_holiday_params)

    respond_to do |format|
      if @custom_holiday.save
        format.html { redirect_to custom_holiday_url(@custom_holiday), notice: "Custom holiday was successfully created." }
        format.json { render :show, status: :created, location: @custom_holiday }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @custom_holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /custom_holidays/1 or /custom_holidays/1.json
  def update
    respond_to do |format|
      if @custom_holiday.update(custom_holiday_params)
        format.html { redirect_to custom_holiday_url(@custom_holiday), notice: "Custom holiday was successfully updated." }
        format.json { render :show, status: :ok, location: @custom_holiday }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @custom_holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_holidays/1 or /custom_holidays/1.json
  def destroy
    @custom_holiday.destroy

    respond_to do |format|
      format.html { redirect_to custom_holidays_url, notice: "Custom holiday was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_holiday
      @custom_holiday = CustomHoliday.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def custom_holiday_params
      params.require(:custom_holiday).permit(:date, :description)
    end
end
