class OrdersController < ApplicationController

	before_action :require_login, only: [:create_order, :get_orders_by_user_id]
	before_action :get_order_with_auth_check, only: [:show, :destroy, :pay_order]

	def create_order
		@current_cart = Cart.find_by(user_id: params[:user_id])
		raise ActiveRecord::RecordNotFound if @current_cart.blank?
		@cart_items = @current_cart.cart_items
		@new_order = Order.new
		@new_order.user_id = params[:user_id]
		@new_order.address_id = params[:address_id]
		@new_order.payment_id = params[:payment_id]
		@new_order.aasm_state = 'order_placed'
		@new_order.is_paid = 0
		@new_order.shipping_fee = params[:shipping_fee]
		Cart.transaction do
			@new_order.save!
			count = 0
			amount = 0
			@cart_items.each do |cart_item|
				image = set_order_image(@new_order.id, cart_item.product_id, cart_item.product.images[0])
				@new_order.create_detail_item(cart_item.product, cart_item.quantity, cart_item.price, '', image)
				count += cart_item.quantity
				amount += cart_item.quantity * cart_item.price
				@product = Product.find(cart_item.product_id)
				if @product.quantity < cart_item.quantity
					# TODO error handling
					raise "Order failed. ErrCode: xxx / ErrMessage: quantity not enough"
				else
					@product.update!(quantity: @product.quantity - cart_item.quantity)
				end
			end
			@new_order.update!(product_count: count, amount_total: amount)
			@current_cart.destroy!
			render json: {order_id: @new_order.id}
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
		@payment = Payment.find(@order.payment_id)
		render :json => {:order => @order, :order_details => @order_details, :address => @address, :payment => @payment}
	end

	def destroy
		@order = get_order_with_auth_check
		@order_details = @order.order_details
		Order.transaction do
			for detail in @order_details do
				@product = Product.find(detail.product_id)
				@product.update!(quantity: @product.quantity+detail.quantity)
			end
			@order.cancel_order!
		end
		render json: @order
	end

	def pay_order
		@order = get_order_with_auth_check
		@order.pay!
		@order.make_payment!
		render json: @order
	end

	def receive_good
		@order = get_order_with_auth_check
		@order.deliver!
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
		
		# TODO local image directory
		def set_order_image(order_id, product_id, file_name)
			src_image = Rails.root.join(file_name.thumb.current_path)
			dest_dir = Rails.root.join('public', 'uploads', 'order', order_id.to_s, product_id.to_s)
			dest_image = Rails.root.join(dest_dir, 'thumb_' + file_name.identifier)
			if !File.exist?(dest_dir)
				FileUtils.mkdir_p(dest_dir)
			end
			FileUtils.cp(src_image, dest_image)
			return File.join('','uploads', 'order', order_id.to_s, product_id.to_s, 'thumb_' + file_name.identifier)
		end

end
