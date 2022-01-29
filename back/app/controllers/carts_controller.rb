class CartsController < ApplicationController

	before_action :require_login, only: [:find_cart_items, :get_checkout_info, :remove_from_cart]

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
		else
			@cart_items = cart.cart_items
			render json: {productList: @cart_items}
		end
	end

	def get_checkout_info
		@cart = Cart.find_by(user_id: params[:user_id])
		raise ActiveRecord::RecordNotFound if @cart.blank?
		@cart_items = @cart.cart_items
		@address = Address.where("user_id = ? AND is_default = 1", params[:user_id])
		@payment = Payment.where("user_id = ? AND is_default = 1", params[:user_id])
		# as_json	vs to_json, to_json	with escape
		render :json => {:cart_items => @cart_items.as_json(:include => :product), :address => @address, :payment => @payment}
  end

	def show_cart_products
		@products = Product.where(id: params[:ids])
		render json: @products
	end

	def remove_from_cart
			@current_cart = Cart.find_by(user_id: params[:user_id])
			raise ActiveRecord::RecordNotFound if @current_cart.blank?
			@cart_item = @current_cart.cart_items.find_by(product_id: params[:product_id])
			if !@cart_item.destroy
				render response_unprocessable_entity(@cart_item.errors)
			end
	end

end
