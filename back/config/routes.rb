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
  post '/login', to: 'authentications#create'
  get '/user/current_user', to: 'users#current_user'
  get '/cart/find_cart/:user_id', to: 'carts#find_products'
  get '/product/show_cart_products', to:'products#showCartProducts'
end
