class Admin::ProductsController < ApplicationController

    before_action :require_login, :require_admin
    
    def create
        @product = Product.new(product_params)
        @product.images = set_images
        if !@product.save!
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
        @product.images = set_images
        if !@product.update!(product_params)
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
        params.permit(:title, :description, :price, :quantity, {images:[]})
    end

    def set_images
        images = Array.new
        images[0] = params[:image1] if params[:image1]
        images[1] = params[:image2] if params[:image2]
        images[2] = params[:image3] if params[:image3]
        return images
    end
end
