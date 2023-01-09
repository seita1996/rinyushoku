Rails.application.routes.draw do
  resources :schedules
  resources :custom_holidays
  root to: 'schedules#index'
  resources :meals do
    collection do
      post :import
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
