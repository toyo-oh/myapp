Rails.application.routes.draw do
  root 'products#index' 
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :admin do
    resources :products
  end
  resources :products do
    member do
      post 'add_to_cart'
    end
  end
  resources :carts
  post '/login', to: 'users#login'
  get '/user/me', to: 'users#find_user_by_token'
end
