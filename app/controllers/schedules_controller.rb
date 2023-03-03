class SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[show edit update destroy]

  # GET /schedules or /schedules.json
  def index
    set_date_range
    @schedules = Schedule.includes(meal: :foods).where(date: [@from..@to])
  end

  # GET /schedules/1 or /schedules/1.json
  def show; end

  # GET /schedules/new
  def new
    @schedule = Schedule.new
  end

  # GET /schedules/1/edit
  def edit; end

  # POST /schedules or /schedules.json
  def create
    @schedule = Schedule.new(schedule_params)

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to schedule_url(@schedule), notice: 'Schedule was successfully created.' }
        format.json { render :show, status: :created, location: @schedule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schedules/1 or /schedules/1.json
  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to schedule_url(@schedule), notice: 'Schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1 or /schedules/1.json
  def destroy
    @schedule.destroy

    respond_to do |format|
      format.html { redirect_to schedules_url, notice: 'Schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /schedules/recalculate
  def recalculate
    respond_to do |format|
      if RecalculateSchedule.call(day: params[:day], start_date: params[:start_date])
        format.html { redirect_to schedules_url, notice: 'スケジュールの再計算が完了しました' }
      else
        format.html { redirect_to schedules_url, alert: 'スケジュールの再計算が失敗しました' }
      end
      format.json { head :no_content }
    end
  end

  def sum
    set_date_range
    @schedules = Schedule.includes(meal: :foods).where(date: [@from..@to])
    @foods = Schedule.sum_foods(@schedules)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def schedule_params
    params.require(:schedule).permit(:date)
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
