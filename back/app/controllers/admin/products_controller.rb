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

    def show
        render json: @product
    end

    def update
        if @product.update(product_params)
            render json: @product
        else
            render json: @product.errors, status: :unprocessable_entity
        end
    end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy 
        render json: {message:"The product was successfully deleted."}
    else
        render json: @product.errors, status: :unprocessable_entity
    end   
  end



    private
    def product_params
        params.require(:product).permit(:title, :description, :price, :quantity)
    end 
end
