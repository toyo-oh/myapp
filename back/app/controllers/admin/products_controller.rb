class Admin::ProductsController < ApplicationController

    before_action :require_login, :require_admin
    
    def create
        @product = Product.new(product_params)
        if !@product.save
            render response_unprocessable_entity(@product.errors)
        end
    end

    def index
        @products = Product.all
        render json: @products
    end

    def show
        @product = Product.find(params[:id])
        render json: @product
    end

    def update
        @product = Product.find(params[:id])
        if !@product.update(product_params)
            render response_unprocessable_entity(@product.errors)
        end
    end

  def destroy
    @product = Product.find(params[:id])
    if !@product.destroy 
        render response_unprocessable_entity(@product.errors)
    end
  end


    private
    def product_params
        params.permit(:title, :description, :price, :quantity,:image)
    end 
end
