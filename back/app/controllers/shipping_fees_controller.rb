class ShippingFeesController < ApplicationController
  def index; end

  def show
    @shipping_fee = ShippingFee.find(params[:id])
    render json: @shipping_fee
  end
end
