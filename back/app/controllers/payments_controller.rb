class PaymentsController < ApplicationController

	before_action :require_login, only: [:create, :find_by_user_id, :set_default]
	before_action :get_payment_with_auth_check, only: [:show, :update, :destroy]

	def create
		user_id = decode_user_id(params[:user_id])
		@payment = Payment.new(payment_params)
		@payment.user_id = user_id;
		if !Payment.exists?(user_id: user_id)
			@payment.is_default = 1
		end
		if !@payment.save
			render response_unprocessable_entity(@payment.errors)
		else
			render json: {code:'ok', message:'added payment way successfully!'}
		end
	end

	def find_by_user_id
		user_id = decode_user_id(params[:user_id])
		@payments = Payment.where(user_id: user_id)
		render json: { payments: @payments.as_json(methods: [:hashid, :user_hashid], except:[:id, :created_at, :updated_at]) } 
	end

	def show
		@payment = get_payment_with_auth_check
		render json: @payment.wrap_json_payment
	end

	def update
		@payment = get_payment_with_auth_check
		if !@payment.update(payment_params)
			render response_unprocessable_entity(@payment.errors)
		else
			render json: {code:'ok', message:'updated payment Successfully!'}
		end
	end

	def destroy
		@payment = get_payment_with_auth_check
		if !@payment.destroy
			render response_unprocessable_entity(@payment.errors)
		else
			render json: {code:'ok', message:'deleted payment Successfully!'}
		end
	end

	def set_default
		@new_payment = get_payment_with_auth_check
		@old_payment = Payment.find(params[:old_id])
		Payment.transaction do
			@old_payment.update!(is_default: 0)
			@new_payment.update!(is_default: 1)
		end
		render json: {code:'ok', message:'set default payment way successfully!'}
	end

	private
	def payment_params
		params.permit(:holder_name, :card_number, :expiration_date, :security_code)
	end 

	def get_payment_with_auth_check
		if validate_user.blank?
				response_unauthorized
		else
			if params[:id].blank?
				@payment = Payment.find(params[:hashid])
			else
				@payment = Payment.find(params[:id])
			end
			if validate_user.id == @payment.user_id
				return @payment
			else
				response_unauthorized
			end
		end
	end
end
