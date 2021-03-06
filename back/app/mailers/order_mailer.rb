class OrderMailer < ApplicationMailer
  default from: 'monstercf.service@gmail.com'

  def notify_order_placed(order)
    @order = order
    @user = order.user
    @order_details = @order.order_details
    @address = Address.find(@order.address_id)
    mail(to: @user.email, subject: "【MonsterCoffee】Order# #{order.order_no} confirmed")
  end

  def notify_order_despatched(order)
    @order = order
    @user = order.user
    @track_url = 'https://monstercf.net/orders'
    mail(to: @user.email, subject: "【MonsterCoffee】Order# #{order.order_no} despatched")
  end

  def notify_order_cancelled(order)
    @order = order
    @user = order.user
    @order_details = @order.order_details
    @address = Address.find(@order.address_id)
    mail(to: @user.email, subject: "【MonsterCoffee】Order# #{order.order_no} cancelled")
  end
end
