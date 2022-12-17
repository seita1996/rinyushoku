class HolidaysController < ApplicationController
  include Common

  before_action :set_holiday, only: %i[ show edit update destroy ]

  # GET /holidays or /holidays.json
  def index
    @holidays = Holiday.all
  end

  # GET /holidays/1 or /holidays/1.json
  def show
  end

  # GET /holidays/new
  def new
    @holiday = Holiday.new
  end

  # GET /holidays/1/edit
  def edit
  end

  # POST /holidays or /holidays.json
  def create
    @holiday = Holiday.new(holiday_params)

    respond_to do |format|
      if @holiday.save
        format.html { redirect_to holiday_url(@holiday), notice: "Holiday was successfully created." }
        format.json { render :show, status: :created, location: @holiday }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /holidays/1 or /holidays/1.json
  def update
    respond_to do |format|
      if @holiday.update(holiday_params)
        format.html { redirect_to holiday_url(@holiday), notice: "Holiday was successfully updated." }
        format.json { render :show, status: :ok, location: @holiday }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  def bulk_update
    # 今年と来年の祝日データを一括更新
    # TODO: ロジックをController外へ移動
    this_year = Date.today.year
    this_year_res = call_api("https://holidays-jp.shogo82148.com/#{this_year}")
    next_year_res = call_api("https://holidays-jp.shogo82148.com/#{this_year + 1}")
    holidays = JSON.parse(this_year_res)['holidays'] + JSON.parse(next_year_res)['holidays']
    # logger.debug(holidays)
    Holiday.delete_all
    Holiday.insert_all(holidays)
    redirect_to holidays_url
  end

  # DELETE /holidays/1 or /holidays/1.json
  def destroy
    @holiday.destroy

    respond_to do |format|
      format.html { redirect_to holidays_url, notice: "Holiday was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def holiday_params
      params.require(:holiday).permit(:name, :date)
    end
end
