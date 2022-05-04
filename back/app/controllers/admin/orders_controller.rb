class Admin::OrdersController < ApplicationController
  before_action :require_login, :require_admin

  def index
    @orders = Order.all.order(created_at: :desc)
    render json: { orders: @orders.as_json(
      methods: :user_hashid,
      except: %i[id user_id updated_at],
      include: { order_details: { methods: [:product_hashid],
                                  except: %i[id order_id product_id created_at updated_at] } }
    ) }
  end

  def show_order_by_no
    @order = find_order
    @address = Address.find(@order.address_id)
    render json: {
      order: @order.wrap_json_order,
      order_details: @order.order_details.as_json(methods: [:product_hashid],
                                                  except: %i[id
                                                             order_id product_id created_at updated_at]),
      address: @address
    }
  end

  # cancel
  def cancel_order
    @order = find_order
    @order_details = @order.order_details
    errors = []
    begin
      refund = refund_by_stripe(@order.charge_id)
    rescue Stripe::StripeError => e
      logger.error "#{e.class} / #{e.message}"
      errors << e.message
    end
    if !errors.present? and refund.status == 'succeeded'
      Order.transaction do
        @order_details.each do |detail|
          @product = Product.find(detail.product_id)
          @product.update!(quantity: @product.quantity + detail.quantity)
        end
        @order.refund!(refund.id)
        OrderMailer.notify_order_cancelled(@order).deliver_now
      end
    else
      return response_custom_error('error', errors)
    end
    render json: { message: 'cancelled order successfully!', order: @order.wrap_json_order }
  end

  # ship
  def ship_order
    @order = find_order
    @order.set_deliver_info!(params[:slug], params[:tracking_number])
    @order.ship!
    OrderMailer.notify_order_despatched(@order).deliver_now
    render json: { message: 'shipped order successfully!', order: @order.wrap_json_order }
  end

  private

  def find_order
    @order = if !params[:order_no].blank?
               Order.find_by!(order_no: params[:order_no])
             else
               Order.find(params[:id])
             end
  end

  def refund_by_stripe(charge_id)
    Stripe::Refund.create({ charge: charge_id })
  end
end
