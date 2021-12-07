class AddressesController < ApplicationController

	def index
		@addresses = Address.all
		render json: @addresses
	end

	def find_by_user_id
		# logger.debug("user_id:"+ params[:user_id])
		@addresses = Address.where(user_id: params[:user_id])
		render json: @addresses
	end

	def create
		@address = Address.new(address_params)
		if @address.save
				render "index", formats: :json
		else
				render json: @address.errors, status: :unprocessable_entity
		end 
	end

	def show
		@address = Address.find(params[:id])
		render json: @address
	end

	def update
		@address = Address.find(params[:id])
		if @address.update(address_params)
				render "index", formats: :json
		else
				render json: @address.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@address = Address.find(params[:id])
		if @address.destroy 
				render "index", formats: :json
		else
				render json: @address.errors, status: :unprocessable_entity
		end
	end


	private
	def address_params
		params.permit(:id, :user_id, :receiver, :phone_number, :post_code, :detail_address)
	end 

end
