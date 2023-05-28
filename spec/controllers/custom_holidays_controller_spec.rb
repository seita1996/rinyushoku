require 'rails_helper'

RSpec.describe CustomHolidaysController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'assigns all custom holidays as @custom_holidays' do
      custom_holiday = CustomHoliday.create!(date: Date.today, description: 'Test holiday')
      get :index
      expect(assigns(:custom_holidays)).to eq([custom_holiday])
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      custom_holiday = CustomHoliday.create!(date: Date.today, description: 'Test holiday')
      get :show, params: { id: custom_holiday.to_param }
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested custom holiday as @custom_holiday' do
      custom_holiday = CustomHoliday.create!(date: Date.today, description: 'Test holiday')
      get :show, params: { id: custom_holiday.to_param }
      expect(assigns(:custom_holiday)).to eq(custom_holiday)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new custom holiday as @custom_holiday' do
      get :new
      expect(assigns(:custom_holiday)).to be_a_new(CustomHoliday)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      custom_holiday = CustomHoliday.create!(date: Date.today, description: 'Test holiday')
      get :edit, params: { id: custom_holiday.to_param }
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested custom holiday as @custom_holiday' do
      custom_holiday = CustomHoliday.create!(date: Date.today, description: 'Test holiday')
      get :edit, params: { id: custom_holiday.to_param }
      expect(assigns(:custom_holiday)).to eq(custom_holiday)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new CustomHoliday' do
        expect do
          post :create, params: { custom_holiday: { date: Date.today, description: 'Test holiday' } }
        end.to change(CustomHoliday, :count).by(1)
      end

      it 'assigns a newly created custom holiday as @custom_holiday' do
        post :create, params: { custom_holiday: { date: Date.today, description: 'Test holiday' } }
        expect(assigns(:custom_holiday)).to be_a(CustomHoliday)
        expect(assigns(:custom_holiday)).to be_persisted
      end

      it 'redirects to the created custom holiday' do
        post :create, params: { custom_holiday: { date: Date.today, description: 'Test holiday' } }
        expect(response).to redirect_to(CustomHoliday.last)
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e. to display the "new" template)' do
        post :create, params: { custom_holiday: { date: nil, description: 'Test holiday' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the requested custom holiday' do
        custom_holiday = CustomHoliday.create!(date: Date.today, description: 'Test holiday')
        patch :update, params: { id: custom_holiday.to_param, custom_holiday: { description: 'Updated holiday' } }
        custom_holiday.reload
        expect(custom_holiday.description).to eq('Updated holiday')
      end

      it 'assigns the requested custom holiday as @custom_holiday' do
        custom_holiday = CustomHoliday.create!(date: Date.today, description: 'Test holiday')
        patch :update, params: { id: custom_holiday.to_param, custom_holiday: { description: 'Updated holiday' } }
        expect(assigns(:custom_holiday)).to eq(custom_holiday)
      end

      it 'redirects to the custom holiday' do
        custom_holiday = CustomHoliday.create!(date: Date.today, description: 'Test holiday')
        patch :update, params: { id: custom_holiday.to_param, custom_holiday: { description: 'Updated holiday' } }
        expect(response).to redirect_to(custom_holiday)
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e. to display the "edit" template)' do
        custom_holiday = CustomHoliday.create!(date: Date.today, description: 'Test holiday')
        patch :update, params: { id: custom_holiday.to_param, custom_holiday: { date: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested custom holiday' do
      custom_holiday = CustomHoliday.create!(date: Date.today, description: 'Test holiday')
      expect do
        delete :destroy, params: { id: custom_holiday.to_param }
      end.to change(CustomHoliday, :count).by(-1)
    end

    it 'redirects to the custom holidays list' do
      custom_holiday = CustomHoliday.create!(date: Date.today, description: 'Test holiday')
      delete :destroy, params: { id: custom_holiday.to_param }
      expect(response).to redirect_to(custom_holidays_url)
    end
  end
end
