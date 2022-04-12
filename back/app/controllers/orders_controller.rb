class OrdersController < ApplicationController

	before_action :require_login, only: [:create_order, :get_orders_by_user_id]
	before_action :get_order_with_auth_check, only: [:show, :destroy, :pay_order]

	def create_order
		@user = User.find(params[:user_id])
		@current_cart = Cart.find_by(user_id: @user.id)
		raise ActiveRecord::RecordNotFound if @current_cart.blank?
		@cart_items = @current_cart.cart_items
		@new_order = Order.new
		@new_order.user_id = @user.id
		@new_order.address_id = decode_address_id(params[:address_id])
		@new_order.aasm_state = 'order_placed'
		@new_order.is_paid = 0
		@new_order.shipping_fee = params[:shipping_fee]
		count, amount = cal_items_sum(@cart_items)
		@new_order.product_count = count
		@new_order.amount_total = amount
		errors = []
		ActiveRecord::Base.transaction do
			@new_order.save!
			@cart_items.each do |cart_item|
				image = set_order_image(@new_order.id, cart_item.product_id, cart_item.product.images[0])
				@new_order.create_detail_item(cart_item.product, cart_item.quantity, cart_item.price, '', image, @new_order.order_no)
				@product = Product.find(cart_item.product_id)
				if @product.quantity < cart_item.quantity
					error_message = "Order failed.quantity not enough."
					errors << error_message
					logger.error error_message
				else
					@product.update!(quantity: @product.quantity - cart_item.quantity)
				end
			end
			@current_cart.destroy!
			begin
				customer, charge = pay_by_stripe(@user.email, amount)
			rescue Stripe::StripeError => e
				logger.error "#{e.class} / #{e.message}"
				errors << e.message
			end
			if errors.present?
				raise ActiveRecord::Rollback 
			else
				@new_order.pay!(customer.id, charge.id, charge.source.last4)
				OrderMailer.notify_order_placed(@new_order).deliver_now
			end
		end
		return response_custom_error("error", errors) if errors.present?
		return render json: {order_no: @new_order.order_no}
	end

	def get_orders_by_user_id
		@orders = Order.where(user_id: decode_user_id(params[:user_id]))
		if !@orders.blank?
			render :json => {:orders => @orders.as_json(
				methods: :user_hashid, 
				except:[:id, :user_id, :updated_at],
				:include => {order_details: {methods: [:product_hashid], except:[:id, :order_id, :product_id, :created_at, :updated_at]}})}
		end
	end

	def show_order_by_no
		@order = get_order_with_auth_check
		@address = Address.find(@order.address_id)
		render :json => {
			:order => @order.wrap_json_order, 
			:order_details => @order.order_details.as_json(methods: [:product_hashid], except:[:id, :order_id, :product_id, :created_at, :updated_at]), 
			:address => @address.wrap_json_address
		}
	end

	def cancel_order
		@order = get_order_with_auth_check
		@order_details = @order.order_details
		Order.transaction do
			@order_details.each do |detail|
				@product = Product.find(detail.product_id)
				@product.update!(quantity: @product.quantity + detail.quantity)
			end
			@order.cancel!
			OrderMailer.notify_order_cancelled(@order).deliver_now
		end
		render json: @order.wrap_json_order
	end

	# NOT IN USE
	# def pay_order
	# 	@order = get_order_with_auth_check
	# 	@order.pay!
	# 	@order.make_payment!
	# 	render json: @order.wrap_json_order
	# end

	def receive_good
		@order = get_order_with_auth_check
		@order.deliver!
		render json: @order.wrap_json_order
	end

	# TODO
	def refund
	end

	private
		def get_order_with_auth_check
			if validate_user.blank?
					response_unauthorized
			else
				if !params[:order_no].blank?
					@order = Order.find_by!(order_no: params[:order_no])
				else
					@order = Order.find(params[:id])
				end
				if validate_user.id == @order.user_id
					return @order
				else
					response_unauthorized
				end
			end
		end
		
		def cal_items_sum(cart_items)
			count = 0
			amount = 0
			cart_items.each do |cart_item|
				count += cart_item.quantity
				amount += cart_item.quantity * cart_item.price
			end
			return count, amount
		end

		def pay_by_stripe(email, amount)
			customer = Stripe::Customer.create({
				email: email,
				source: params[:stripe_token],
			})
			charge = Stripe::Charge.create({
				customer: customer.id,
				amount: amount,
				description: 'Coffee Monster Stripe customer',
				currency: 'jpy',
			})
			return customer, charge
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