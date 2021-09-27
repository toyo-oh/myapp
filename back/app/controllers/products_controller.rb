
class ProductsController < ApplicationController
    def index
        @products = Product.all
        render json: @products
    end

    def show
        @product = Product.find(params[:id])
        render json: @product
    end

    def add_to_cart
        @product = Product.find(params[:id])
        render json: "add to cart!!!"
    end
end
