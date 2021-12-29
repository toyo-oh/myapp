class OrdersController < ApplicationController

	def create_order
		user_id = params[:user_id]
		address_id = params[:address_id]
		@current_cart = Cart.find_by(user_id: params[:user_id])
		# cart is not exist
		if @current_cart.blank?
			render json: "backend: create order failed! cart is not exist!!!"
		else
			@cart_items = @current_cart.cart_items
			if @cart_items.blank?
				render json: "backend: create order failed! there is no cart items!!!"
			else
				@new_order = Order.new
				# TODO how to increase order no ???
				@new_order.user_id = user_id
				@new_order.address_id = address_id
				@new_order.aasm_state = 'order_placed'
				@new_order.is_paid = 0
			  # TODO loop the cart_items
				if @new_order.save
					count = 0
					amount = 0
					for cart_item in @cart_items do
						@new_order.create_detail_item(cart_item.product,cart_item.quantity,'')
						count += cart_item.quantity
						amount += cart_item.quantity * cart_item.price
					end
					@new_order.update(product_count: count, amount_total: amount)
					@current_cart.destroy
					render json: {order_id: @new_order.id}
				else
					render json: "backend: create order failed!"
				end
			end
		end
	end

	def show
		@order = Order.find(params[:id])
		if @order.blank?
			render json: 'backend: error! no order!'
		else
			@order_details = @order.order_details
			@address = Address.find(@order.address_id)
			render :json => {:order => @order, :order_details => @order_details.as_json(:include => :product), :address => @address}
		end
	end

	def get_orders_by_user_id
		@orders = Order.where(user_id: params[:user_id])
		if @orders.blank?
			render json: 'backend: error! there is no order existed!'
		else
			render :json => {:orders => @orders.as_json(:include => :order_details)}
		end
	end

	def destroy
		@order = Order.find(params[:id]);
		if @order.blank?
			render json: 'backend: error! no order!'
		else
			# TODO when status=paid -> refund??
			@order.cancel_order!
		end
	end

	def pay_order
		@order = Order.find(params[:order_id])
		if @order.blank?
			render json: 'backend: error! no order!'
		else
			# if @order.update(is_paid: true, order_status: "paid")
			@order.pay!
			@order.make_payment!
			render json: "backend: pay successfully!"
		end
	end

end
