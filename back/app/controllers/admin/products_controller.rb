class Admin::ProductsController < ApplicationController
    
    def create
        @product = Product.new(product_params)
        if @product.save
            render json: @product, status: :created, location: @product
        else
            render json: @product.errors, status: :unprocessable_entity
        end 
    end

    def index
        @products = Product.all
        render json: @products
    end



    private
    def product_params
        params.require(:product).permit(:title, :description, :price, :quantity)
    end 
end
