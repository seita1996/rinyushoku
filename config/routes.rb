Rails.application.routes.draw do
  root to: 'meals#index'
  resources :meals do
    collection do
      post :import
      get :sum_foods
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
