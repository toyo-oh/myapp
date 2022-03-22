class Admin::OrdersController < ApplicationController

	before_action :require_login, :require_admin

	def index
		@orders = Order.all
		render :json => {:orders => @orders.as_json(:include => :order_details)}
	end

	def show_order_by_no
		@order = Order.find_by!(order_no: params[:order_no])
		@order_details = @order.order_details
		@address = Address.find(@order.address_id)
		@payment = Payment.find(@order.payment_id)
		render :json => {:order => @order, :order_details => @order_details, :address => @address, :payment => @payment}
	end

	# cancel
	def cancel_order
		@order = Order.find(params[:id]);
		@order.cancel!
		OrderMailer.notify_order_cancelled(@order).deliver_now
		render json: @order
	end

	# ship
	def ship_order
		@order = Order.find(params[:id]);
		@order.set_deliver_at!
		@order.ship!
		OrderMailer.notify_order_despatched(@order).deliver_now
		render json: @order
	end
	
end
