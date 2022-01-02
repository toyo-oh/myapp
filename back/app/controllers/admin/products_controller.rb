class Admin::ProductsController < ApplicationController
    
    def create
        @product = Product.new(product_params)
        if @product.save
            render "index", formats: :json
        else
            render json: @product.errors, status: :unprocessable_entity
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
        if @product.update(product_params)
            render "index", formats: :json
        else
            render json: @product.errors, status: :unprocessable_entity
        end
    end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy 
        render "index", formats: :json
    else
        render json: @product.errors, status: :unprocessable_entity
    end
  end



    private
    def product_params
        params.permit(:title, :description, :price, :quantity,:image)
    end 
end
