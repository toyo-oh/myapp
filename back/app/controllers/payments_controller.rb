class PaymentsController < ApplicationController

	before_action :require_login, only: [:create, :find_by_user_id, :set_default]
	before_action :get_payment_with_auth_check, only: [:show, :update, :destroy]

	def create
		@payment = Payment.new(payment_params)
		if !Payment.exists?(user_id: params[:user_id])
			@payment.is_default = 1
		end
		if !@payment.save
			render response_unprocessable_entity(@payment.errors)
		end
	end

	def find_by_user_id
		@payments = Payment.where(user_id: params[:user_id])
		render json: @payments
	end

	def show
		@payment = get_payment_with_auth_check
		render json: @payment
	end

	def update
		@payment = get_payment_with_auth_check
		if !@payment.update(payment_params)
			render response_unprocessable_entity(@payment.errors)
		end
	end

	def destroy
		@payment = get_payment_with_auth_check
		if !@payment.destroy
			render response_unprocessable_entity(@payment.errors)
		end
	end

	def set_default
		@new_payment = get_payment_with_auth_check
		@old_payment = Payment.find(params[:old_id])
		Payment.transaction do
			@old_payment.update!(is_default: 0)
			@new_payment.update!(is_default: 1)
		end
	end

	private
	def payment_params
		params.permit(:id, :user_id, :holder_name, :card_number, :expiration_date, :security_code)
	end 

	def get_payment_with_auth_check
		if validate_user.blank?
				response_unauthorized
		else
			@payment = Payment.find(params[:id])
			if validate_user.id == @payment.user_id
				return @payment
			else
				response_unauthorized
			end
		end
	end
end
