class ReviewsController < ApplicationController

	before_action :require_login, only: [:create]

	def create
		params[:user_id] = decode_user_id(params[:user_id])
		params[:product_id] = decode_product_id(params[:product_id])
		@review = Review.new(review_params)
		if !@review.save!
			render response_unprocessable_entity(@review.errors)
		end
	end

	def find_by_product_id
		@product = Product.find(params[:phashid])
		@reviews = Review.where(product_id: @product.id)
		render :json => {:reviews => @reviews.as_json(only: [:rate, :comment, :created_at], :include => {user: {only: :name}})}
	end

	private
	def review_params
			params.permit(:product_id, :user_id, :comment, :rate)
	end
end
