class CartsController < ApplicationController
  before_action :require_login, only: %i[find_cart_items find_checkout_info remove_from_cart]

  def current_cart
    @current_cart ||= find_cart
  end

  def find_cart
    cart = Cart.find(id: session[:cart_id])
    cart = Cart.create if cart.blank?
    session[:cart_id] = cart_id
    cart
  end

  def find_cart_items
    cart = Cart.find_by(user_id: decode_user_id(params[:user_id]))
    if cart.blank?
      render json: { productList: [] }
    else
      @cart_items = cart.cart_items
      render json: { productList: @cart_items.as_json(methods: [:product_hashid],
                                                      except: %i[id cart_id product_id created_at updated_at]) }
    end
  end

  def find_checkout_info
    user_id = decode_user_id(params[:user_id])
    @cart = Cart.find_by(user_id: user_id)
    if @cart.blank?
      response_custom_error('error', 'The cart is not exist.')
    else
      @cart_items = @cart.cart_items
      @address = Address.where('user_id = ? AND is_default = 1', user_id).take
      @payment = Payment.where('user_id = ? AND is_default = 1', user_id).take
      render json: {
        cart_items: @cart_items.as_json(include: :product, methods: [:product_hashid],
                                        except: %i[created_at updated_at product_id]), 
        address: @address.present? ? @address.wrap_json_address : nil ,
        payment: @payment.present? ? @payment.wrap_json_payment : nil
      }
    end
  end

  def show_cart_products
    if params[:hashids].blank?
      render json: { products: [] }
    else
      ids = []
      params[:hashids].each do |item|
        ids.push(decode_product_id(item))
      end
      @products = Product.where(id: ids)
      @products.each do |item|
        item.discount = ProductsController.cal_discount(item)
      end
      render json: { products: @products.as_json(methods: [:hashid], except: %i[created_at updated_at id]) }
    end
  end

  def remove_from_cart
    user_id = decode_user_id(params[:user_id])
    product_id = decode_product_id(params[:product_id])
    @current_cart = Cart.find_by(user_id: user_id)
    if @current_cart.blank?
      response_custom_error('error', 'The cart is not exist.Please try again.')
    else
      @cart_item = @current_cart.cart_items.find_by(product_id: product_id)
      if !@cart_item.destroy
        render response_unprocessable_entity(@cart_item.errors)
      else
        render json: { code: 'ok', message: 'removed item successfully!' }
      end
    end
  end

  def cal_shipping_fee
    @shipping_fee = ShippingFee.find(id: params[:prefecture_id])
    raise ActiveRecord::RecordNotFound if @shipping_fee.blank?

    render json: @shipping_fee
  end
end
