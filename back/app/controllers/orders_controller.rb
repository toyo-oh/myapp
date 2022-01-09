class OrdersController < ApplicationController

	before_action :require_login, only: [:create_order, :get_orders_by_user_id]
	before_action :get_order_with_auth_check, only: [:show, :destroy, :pay_order]

	def create_order
		user_id = params[:user_id]
		address_id = params[:address_id]
		@current_cart = Cart.find_by(user_id: params[:user_id])
		@cart_items = @current_cart.cart_items
		@new_order = Order.new
		@new_order.user_id = user_id
		@new_order.address_id = address_id
		@new_order.aasm_state = 'order_placed'
		@new_order.is_paid = 0
		if @new_order.save
			count = 0
			amount = 0
			# TODO 另一种写法：current_cart.cart_items.each do |cart_item|
			for cart_item in @cart_items do
				@new_order.create_detail_item(cart_item.product,cart_item.quantity,'')
				count += cart_item.quantity
				amount += cart_item.quantity * cart_item.price
			end
			@new_order.update(product_count: count, amount_total: amount)
			@current_cart.destroy
			render json: {order_id: @new_order.id}
		else
			render response_unprocessable_entity(@new_order.errors)
		end
	end

	def get_orders_by_user_id
		@orders = Order.where(user_id: params[:user_id])
		if !@orders.blank?
			render :json => {:orders => @orders.as_json(:include => :order_details)}
		end
	end

	def show
		@order = get_order_with_auth_check
		@order_details = @order.order_details
		@address = Address.find(@order.address_id)
		render :json => {:order => @order, :order_details => @order_details.as_json(:include => :product), :address => @address}
	end

	def destroy
		@order = get_order_with_auth_check
		@order.cancel_order!
		render json: @order
	end

	def pay_order
		@order = get_order_with_auth_check
		@order.pay!
		@order.make_payment!
		render json: @order
	end

	private
		def get_order_with_auth_check
			if validate_user.blank?
					response_unauthorized
			else
				@order = Order.find(params[:id])
				if validate_user.id == @order.user_id
					return @order
				else
					response_unauthorized
				end
			end
		end

end
