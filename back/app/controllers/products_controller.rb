class ProductsController < ApplicationController

    before_action :require_login, only: [:add_to_cart, :decrease_of_cart]

    def index
        @products = Product.all
        render json: @products
    end

    def show
        @product = Product.find(params[:id])
        render json: @product
    end 

    def add_to_cart
        @product = Product.find(params[:product_id])
        @current_cart = Cart.find_by(user_id: params[:user_id])
        # cart is not exist
        if @current_cart.blank?
            @new_cart = Cart.new(user_id: params[:user_id])
            if @new_cart.save
                @new_cart.add_product_to_cart(@product,params[:user_id])
            else
                render response_unprocessable_entity(@new_cart.errors)
            end
        else
            # cart is alreay exist
            @cart_item = @current_cart.cart_items.find_by(product_id: params[:product_id])
            if @cart_item.blank?
                @current_cart.add_product_to_cart(@product,params[:user_id])
            else
                new_count = @cart_item.quantity + 1
                @cart_item.update(quantity: new_count)
            end
        end
    end

    def decrease_of_cart
        @current_cart = Cart.find_by(user_id: params[:user_id])
        @cart_item = @current_cart.cart_items.find_by(product_id: params[:product_id])
        if @cart_item.quantity == 1
            @cart_item.destroy
        else
            new_count = @cart_item.quantity - 1
            @cart_item.update(quantity: new_count)
        end
    end
end
