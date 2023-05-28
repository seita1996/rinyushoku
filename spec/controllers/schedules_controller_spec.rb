require 'rails_helper'

RSpec.describe SchedulesController, type: :controller do
  let(:schedule) { create(:schedule) }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'assigns @schedules' do
      get :index
      expect(assigns(:schedules)).to eq([schedule])
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: schedule.id }
      expect(response).to have_http_status(:success)
    end

    it 'assigns @schedule' do
      get :show, params: { id: schedule.id }
      expect(assigns(:schedule)).to eq(schedule)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'assigns @schedule' do
      get :new
      expect(assigns(:schedule)).to be_a_new(Schedule)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { id: schedule.id }
      expect(response).to have_http_status(:success)
    end

    it 'assigns @schedule' do
      get :edit, params: { id: schedule.id }
      expect(assigns(:schedule)).to eq(schedule)
    end
  end

  describe 'POST #create' do
    # context 'with valid params' do
    #   let!(:meal) { create(:meal) }
    #   let(:valid_params) { { schedule: { date: Date.today } } }

    #   it 'creates a new Schedule' do
    #     expect {
    #       post :create, params: valid_params
    #     }.to change(Schedule, :count).by(1)
    #   end

    #   it 'assigns a newly created schedule as @schedule' do
    #     post :create, params: valid_params
    #     expect(assigns(:schedule)).to be_a(Schedule)
    #     expect(assigns(:schedule)).to be_persisted
    #   end

    #   it 'redirects to the created schedule' do
    #     post :create, params: valid_params
    #     expect(response).to redirect_to(schedule_url(Schedule.last))
    #   end
    # end

    context 'with invalid params' do
      let(:invalid_params) { { schedule: { date: nil } } }

      it 'assigns a newly created but unsaved schedule as @schedule' do
        post :create, params: invalid_params
        expect(assigns(:schedule)).to be_a_new(Schedule)
      end

      it 're-renders the "new" template' do
        post :create, params: invalid_params
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:new_date) { Date.today + 1 }
      let(:valid_params) { { id: schedule.id, schedule: { date: new_date } } }

      it 'updates the requested schedule' do
        patch :update, params: valid_params
        schedule.reload
        expect(schedule.date).to eq(new_date)
      end

      it 'assigns the requested schedule as @schedule' do
        patch :update, params: valid_params
        expect(assigns(:schedule)).to eq(schedule)
      end

      it 'redirects to the schedule' do
        patch :update, params: valid_params
        expect(response).to redirect_to(schedule_url(schedule))
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { id: schedule.id, schedule: { date: nil } } }

      it 'assigns the schedule as @schedule' do
        patch :update, params: invalid_params
        expect(assigns(:schedule)).to eq(schedule)
      end

      # it 're-renders the "edit" template' do
      #   patch :update, params: invalid_params
      #   expect(response).to render_template('edit')
      # end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested schedule' do
      schedule
      expect {
        delete :destroy, params: { id: schedule.id }
      }.to change(Schedule, :count).by(-1)
    end

    it 'redirects to the schedules list' do
      delete :destroy, params: { id: schedule.id }
      expect(response).to redirect_to(schedules_url)
    end
  end

  describe 'POST #recalculate' do
    let(:valid_params) { { day: Date.today.wday, start_date: Date.today } }

    context 'when the recalculation is successful' do
      before do
        allow(RecalculateSchedule).to receive(:call).and_return(true)
      end

      it 'redirects to the schedules list with a success message' do
        post :recalculate, params: valid_params
        expect(response).to redirect_to(schedules_url)
        expect(flash[:notice]).to eq('スケジュールの再計算が完了しました')
      end
    end

    context 'when the recalculation fails' do
      before do
        allow(RecalculateSchedule).to receive(:call).and_return(false)
      end

      it 'redirects to the schedules list with an error message' do
        post :recalculate, params: valid_params
        expect(response).to redirect_to(schedules_url)
        expect(flash[:alert]).to eq('スケジュールの再計算が失敗しました')
      end
    end
  end

  describe 'GET #sum' do
    it 'returns http success' do
      get :sum
      expect(response).to have_http_status(:success)
    end

    # it 'assigns @schedules' do
    #   get :sum
    #   expect(assigns(:schedules)).to eq([schedule])
    # end

    # it 'assigns @foods' do
    #   get :sum
    #   expect(assigns(:foods)).to eq([{ id: 1, name: 'food1', amount: '250g' }, { id: 2, name: 'food2', amount: '250g' }])
    # end
  end
end
