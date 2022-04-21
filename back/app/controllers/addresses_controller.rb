class AddressesController < ApplicationController

	before_action :require_login, only: [:create, :find_by_user_id, :set_default]
	before_action :get_address_with_auth_check, only: [:show, :update, :destroy]

	def create
		user_id = decode_user_id(params[:user_id])
		@address = Address.new(address_params)
		@address.user_id = user_id;
		@prefecture_item = ShippingFee.find(params[:prefecture_id])
		@address.detail_address = @prefecture_item.prefecture + params[:city] + params[:detail]
		if !Address.exists?(user_id: user_id)
			@address.is_default = 1
		end
		if !@address.save!
			render response_unprocessable_entity(@address.errors)
		else
			render json: {code:'ok', message:'added new address successfully!'}
		end
	end

	def find_by_user_id
		@addresses = Address.where(user_id: decode_user_id(params[:user_id]))
		render json: { addresses: @addresses.as_json(methods: [:hashid, :user_hashid], except:[:id, :created_at, :updated_at]) } 
	end

	def show
		@address = get_address_with_auth_check
		render json: @address.wrap_json_address
	end

	def update
		@address = get_address_with_auth_check
		@prefecture_item = ShippingFee.find(params[:prefecture_id])
		@address.detail_address = @prefecture_item.prefecture + params[:city] + params[:detail]
		if !@address.update!(address_params)
			render response_unprocessable_entity(@address.errors)
		else
			render json: {code:'ok', message:'updated address successfully!'}
		end
	end

	def destroy
		@address = get_address_with_auth_check
		if !@address.destroy
			render response_unprocessable_entity(@address.errors)
		else
			render json: {code:'ok', message:'deleted address successfully!'}
		end
	end

	def set_default
		@new_address = get_address_with_auth_check
		@old_address = Address.find(params[:old_id])
		Address.transaction do
			@old_address.update!(is_default: 0)
			@new_address.update!(is_default: 1)
		end
		render json: {code:'ok', message:'set default address successfully!'}
	end

	def get_prefectures
		 @prefectures = ShippingFee.find_by_sql("SELECT id, prefecture FROM shipping_fees")
		 render json: @prefectures
	end

	def get_shipping_fee
		@address = Address.find(params[:address_id])
		@shipping_fee = ShippingFee.find(@address.prefecture_id)
		render json: @shipping_fee
	end

	private
	def address_params
		params.permit(:receiver, :phone_number, :post_code, :prefecture_id, :city, :detail)
	end

	def get_address_with_auth_check
		if validate_user.blank?
				response_unauthorized
		else
			if params[:id].blank?
				@address = Address.find(params[:hashid])
			else
				@address = Address.find(params[:id])
			end
			if validate_user.id == @address.user_id
				return @address
			else
				response_unauthorized
			end
		end
	end

end
