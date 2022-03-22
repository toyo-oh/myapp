Rails.application.routes.draw do

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root 'products#index' 
  resources :users
  resources :addresses
  resources :payments
  resources :orders
  resources :carts
  resources :shipping_fees
  resources :reviews
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
  resources :users do
    member do
      post 'update_profile', to:'users#update_profile'
      post 'update_email', to:'users#update_email'
      post 'update_password', to:'users#update_password'
    end
  end
  post '/login', to: 'authentications#create'
  get '/user/current_user', to: 'users#current_user'
  post '/password/forget', to: 'users#forget_password'
  get 'users/reset_password', to: 'users#render_reset_password'
  post '/password/reset_password', to: 'users#reset_password'
  get '/cart/find_cart/:user_id', to: 'carts#find_cart_items'
  get '/cart/get_checkout_info/:user_id', to:'carts#get_checkout_info'
  get '/cart/show_cart_products', to:'carts#show_cart_products'
  post '/cart/remove_from_cart', to:'carts#remove_from_cart'
  get '/cart/cal_shipping_fee/:prefecture_id', to: 'carts#cal_shipping_fee'
  get '/addresses/find_by_user_id/:user_id', to: 'addresses#find_by_user_id'
  post '/addresses/set_default', to: 'addresses#set_default'
  get '/addresses/get_shipping_fee/:address_id', to: 'addresses#get_shipping_fee'
  get  '/prefectures', to: 'addresses#get_prefectures'
  get '/categories', to:'admin/products#get_categories'
  get '/orders/get_orders_by_user_id/:user_id', to: 'orders#get_orders_by_user_id'
  get '/orders/show_order/:order_no', to: 'orders#show_order_by_no'
  post '/order/create_order', to:'orders#create_order'
  post '/orders/cancel_order', to: 'orders#cancel_order'
  post '/orders/pay_order', to: 'orders#pay_order'
  post '/orders/receive_good', to: 'orders#receive_good'
  get '/admin/orders/show_order/:order_no', to: 'admin/orders#show_order_by_no'
  post '/admin/orders/cancel_order', to: 'admin/orders#cancel_order'
  post '/admin/orders/ship_order', to: 'admin/orders#ship_order'
  post '/products/search', to:'products#search'
  get '/payments/find_by_user_id/:user_id', to: 'payments#find_by_user_id'
  post '/payments/set_default', to: 'payments#set_default'
  get '/reviews/find_by_product_id/:product_id', to: 'reviews#find_by_product_id'
end
