class CartsController < ApplicationController
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

	def find_products
		cart = Cart.find_by(user_id: params[:user_id])
		if cart.blank?
			render json: {productList: []}
		else
			@cart_items = cart.cart_items
			render json: {productList: @cart_items}
		end
	end

end
