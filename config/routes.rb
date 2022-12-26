Rails.application.routes.draw do
  resources :custom_holidays
  root to: 'meals#index'
  resources :meals do
    collection do
      post :import
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
