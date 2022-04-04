Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'ideas#index'
  resources :ideas, except: %i[index] do
    resources :reviews, shallow: true, only: %i[create destroy]
    resources :likes, shallow: true, only: %i[create destroy]
  end

  resources :users, only: %i[new create edit update]
  resource :session, only: %i[new create destroy]
end
