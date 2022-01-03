class Admin::OrdersController < ApplicationController

	before_action :require_login, :require_admin

	def index
		@orders = Order.all
		render :json => {:orders => @orders.as_json(:include => :order_details)}
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

	# cancel
	def destroy
		@order = Order.find(params[:id]);
		if @order.blank?
			render json: 'backend: error! no order!'
		else
			@order.cancel_order!
			render json: @order
		end
	end

	# ship
	def ship_order
		@order = Order.find(params[:id]);
		if @order.blank?
			render json: 'backend: error! no order!'
		else
			@order.ship!
			render json: @order
		end
	end
end
