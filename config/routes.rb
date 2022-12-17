Rails.application.routes.draw do
  resources :holidays do
    collection {post :bulk_update}
  end
  root to: 'meals#index'
  resources :meals do
    collection {post :import}
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
