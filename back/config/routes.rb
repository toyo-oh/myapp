Rails.application.routes.draw do
  root 'products#index' 
  resources :users
  resources :addresses
  resources :orders
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :admin do
    resources :products
    resources :orders
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
  get '/cart/show_cart_products', to:'carts#show_cart_products'
  post '/cart/remove_from_cart', to:'carts#remove_from_cart'
  get '/addresses/find_by_user_id/:user_id', to: 'addresses#find_by_user_id'
  post '/order/create_order', to:'orders#create_order'
  get '/orders/get_orders_by_user_id/:user_id', to: 'orders#get_orders_by_user_id'
  post '/orders/pay_order', to: 'orders#pay_order'
  post '/admin/orders/ship_order', to: 'admin/orders#ship_order'
end
