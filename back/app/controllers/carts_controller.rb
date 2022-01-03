class CartsController < ApplicationController

	before_action :require_login, only: [:find_cart_items, :get_checkout_info]

	def current_cart
		@current_cart ||= find_cart
	end

	def find_cart
		cart = Cart.find(id: session[:cart_id])
		if cart.blank?
			cart = Cart.create
		end
		session[:cart_id] = cart_id
		return cart
	end

	def find_cart_items
		cart = Cart.find_by(user_id: params[:user_id])
		if cart.blank?
			render json: {productList:[]}
			# render :json => []
		else
			@cart_items = cart.cart_items
			render json: {productList: @cart_items}
			# render :json => @cart_items, :include => :product
		end
	end

	def get_checkout_info
		cart = Cart.find_by(user_id: params[:user_id])
		if cart.blank?
			render json: 'backend: error! no cart existed!'
		else
			@cart_items = cart.cart_items
			@address = Address.where("user_id = ? AND is_default = 1", params[:user_id])
			# as_json	vs to_json, to_json	with escape
			render :json => {:cart_items => @cart_items.as_json(:include => :product), :address => @address}
		end
  end

	def show_cart_products
		@products = Product.where(id: params[:ids])
		render json: @products
	end

	def remove_from_cart
			@current_cart = Cart.find_by(user_id: params[:user_id])
			@cart_item = @current_cart.cart_items.find_by(product_id: params[:product_id])
			@cart_item.destroy
			render json:'backend: delete product from cart successfully'
	end

end
