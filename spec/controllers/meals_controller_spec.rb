require 'rails_helper'

RSpec.describe MealsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all meals as @meals' do
      meal = create(:meal)
      get :index
      expect(assigns(:meals)).to eq([meal])
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      meal = create(:meal)
      get :show, params: { id: meal.to_param }
      expect(response).to be_successful
    end

    it 'assigns the requested meal as @meal' do
      meal = create(:meal)
      get :show, params: { id: meal.to_param }
      expect(assigns(:meal)).to eq(meal)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new meal as @meal' do
      get :new
      expect(assigns(:meal)).to be_a_new(Meal)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      meal = create(:meal)
      get :edit, params: { id: meal.to_param }
      expect(response).to be_successful
    end

    it 'assigns the requested meal as @meal' do
      meal = create(:meal)
      get :edit, params: { id: meal.to_param }
      expect(assigns(:meal)).to eq(meal)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Meal' do
        expect {
          post :create, params: { meal: attributes_for(:meal) }
        }.to change(Meal, :count).by(1)
      end

      it 'assigns a newly created meal as @meal' do
        post :create, params: { meal: attributes_for(:meal) }
        expect(assigns(:meal)).to be_a(Meal)
        expect(assigns(:meal)).to be_persisted
      end

      it 'redirects to the created meal' do
        post :create, params: { meal: attributes_for(:meal) }
        expect(response).to redirect_to(Meal.last)
      end
    end

    context 'with invalid params' do
      it 'returns a 422 response (i.e. to display the "new" template)' do
        post :create, params: { meal: attributes_for(:meal, day: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'assigns a newly created but unsaved meal as @meal' do
        post :create, params: { meal: attributes_for(:meal, day: nil) }
        expect(assigns(:meal)).to be_a_new(Meal)
      end

      it "re-renders the 'new' template" do
        post :create, params: { meal: attributes_for(:meal, day: nil) }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:new_attributes) { { day: 2 } }

      it 'updates the requested meal' do
        meal = create(:meal)
        patch :update, params: { id: meal.to_param, meal: new_attributes }
        meal.reload
        expect(meal.day).to eq(2)
      end

      it 'assigns the requested meal as @meal' do
        meal = create(:meal)
        patch :update, params: { id: meal.to_param, meal: attributes_for(:meal) }
        expect(assigns(:meal)).to eq(meal)
      end

      it 'redirects to the meal' do
        meal = create(:meal)
        patch :update, params: { id: meal.to_param, meal: attributes_for(:meal) }
        expect(response).to redirect_to(meal)
      end
    end

    context 'with invalid params' do
      it 'returns a 422 response (i.e. to display the "edit" template)' do
        meal = create(:meal)
        patch :update, params: { id: meal.to_param, meal: attributes_for(:meal, day: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'assigns the meal as @meal' do
        meal = create(:meal)
        patch :update, params: { id: meal.to_param, meal: attributes_for(:meal, day: nil) }
        expect(assigns(:meal)).to eq(meal)
      end

      it "re-renders the 'edit' template" do
        meal = create(:meal)
        patch :update, params: { id: meal.to_param, meal: attributes_for(:meal, day: nil) }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested meal' do
      meal = create(:meal)
      expect {
        delete :destroy, params: { id: meal.to_param }
      }.to change(Meal, :count).by(-1)
    end

    it 'redirects to the meals list' do
      meal = create(:meal)
      delete :destroy, params: { id: meal.to_param }
      expect(response).to redirect_to(meals_url)
    end
  end

  describe 'POST #import' do
    let(:file) { fixture_file_upload('rinyushoku_success.csv', 'text/csv') }

    it 'recalculates the schedule' do
      expect(RecalculateSchedule).to receive(:call).with(day: '1', start_date: '2022-01-01')
      post :import, params: { file: file, start_date: '2022-01-01' }
    end

    it 'redirects to the root url' do
      post :import, params: { file: file, start_date: '2022-01-01' }
      expect(response).to redirect_to(root_url)
    end
  end
end
