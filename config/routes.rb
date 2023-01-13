Rails.application.routes.draw do
  resources :schedules do
    collection do
      post :recalculate
    end
  end
  resources :custom_holidays
  root to: 'schedules#index'
  resources :meals do
    collection do
      post :import
    end
  end
  namespace 'api' do
    namespace 'v1' do
      resources :schedules do
        collection do
          get :index
        end
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
