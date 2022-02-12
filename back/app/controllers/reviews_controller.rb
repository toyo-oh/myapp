class ReviewsController < ApplicationController

	before_action :require_login, only: [:create]

	def create
		@review = Review.new(review_params)
		if !@review.save!
			render response_unprocessable_entity(@review.errors)
		end
	end

	def find_by_product_id
		@reviews = Review.where(product_id: params[:product_id])
		render :json => {:reviews => @reviews.as_json(:include => {user: {only: :name}})}
	end

	private
	def review_params
			params.permit(:product_id, :user_id, :comment, :rate)
	end
end
