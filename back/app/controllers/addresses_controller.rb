class AddressesController < ApplicationController

	before_action :require_login, only: [:create, :find_by_user_id]
	before_action :get_address_with_auth_check, only: [:show, :update, :destroy]

	def create
		@address = Address.new(address_params)
		if !Address.exists?(user_id: params[:user_id])
			@address.is_default = 1
		end
		if !@address.save
			render response_unprocessable_entity(@address.errors)
		end
	end

	def find_by_user_id
		@addresses = Address.where(user_id: params[:user_id])
		render json: @addresses
	end

	def show
		@address = get_address_with_auth_check
		render json: @address
	end

	def update
		@address = get_address_with_auth_check
		if !@address.update(address_params)
			render response_unprocessable_entity(@address.errors)
		end
	end

	def destroy
		@address = get_address_with_auth_check
		if !@address.destroy
			render response_unprocessable_entity(@address.errors)
		end
	end


	private
	def address_params
		params.permit(:id, :user_id, :receiver, :phone_number, :post_code, :detail_address)
	end 

	def get_address_with_auth_check
		if validate_user.blank?
				response_unauthorized
		else
			@address = Address.find(params[:id])
			if validate_user.id == @address.user_id
				return @address
			else
				response_unauthorized
			end
		end
	end

end
