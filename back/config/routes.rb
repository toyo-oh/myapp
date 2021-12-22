Rails.application.routes.draw do
  root 'products#index' 
  resources :users
  resources :addresses
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :admin do
    resources :products
  end
  resources :products do
    member do
      post 'add_to_cart'
      post 'decrease_of_cart'
    end
  end
  resources :carts
  post '/login', to: 'authentications#create'
  get '/user/current_user', to: 'users#current_user'
  get '/cart/find_cart/:user_id', to: 'carts#find_cart_items'
  get '/cart/get_checkout_info/:user_id', to:'carts#get_checkout_info'
  get '/product/show_cart_products', to:'products#show_cart_products'
  post '/product/remove_from_cart', to:'products#remove_from_cart'
  get '/addresses/find_by_user_id/:user_id', to: 'addresses#find_by_user_id'
end
