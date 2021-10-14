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
end
