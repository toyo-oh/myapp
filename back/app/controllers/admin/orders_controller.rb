class Admin::OrdersController < ApplicationController

	before_action :require_login, :require_admin

	def index
		@orders = Order.all
		render :json => {:orders => @orders.as_json(
			methods: :user_hashid, 
			except:[:id, :user_id, :updated_at],
			:include => {order_details: {methods: [:product_hashid], except:[:id, :order_id, :product_id, :created_at, :updated_at]}})}
  end

	def show_order_by_no
		@order = find_order
		@address = Address.find(@order.address_id)
		render :json => {
			:order => @order.wrap_json_order, 
			:order_details => @order.order_details.as_json(methods: [:product_hashid], except:[:id, :order_id, :product_id, :created_at, :updated_at]), 
			:address => @address}	
	end

	# cancel
	def cancel_order
		@order = find_order
		@order.cancel!
		OrderMailer.notify_order_cancelled(@order).deliver_now
		render json: @order.wrap_json_order
	end

	# ship
	def ship_order
		@order = find_order
		@order.set_deliver_info!(params[:slug], params[:tracking_number])
		@order.ship!
		OrderMailer.notify_order_despatched(@order).deliver_now
		render json: @order.wrap_json_order
	end

	private
	def find_order
		if !params[:order_no].blank?
			@order = Order.find_by!(order_no: params[:order_no])
		else
			@order = Order.find(params[:id])
		end
	end
	
end
