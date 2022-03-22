class OrderMailer < ApplicationMailer
  default from: 'service@cf.com'

	def notify_order_placed(order)
    @order = order
    @user = order.user
    @order_details = @order.order_details
		@address = Address.find(@order.address_id)
		@payment = Payment.find(@order.payment_id)
    mail(to: @user.email, subject: "[MonsterCoffee] Order# #{order.id} confirmed")
  end

	def notify_order_despatched(order)
		@order = order
    @user = order.user
		@track_url  = 'http://monstercoffee.com/track'
    mail(to: @user.email, subject: "[MonsterCoffee] Order# #{order.id} despatched")
	end
	
	def notify_order_cancelled(order)
		@order = order
    @user = order.user
    @order_details = @order.order_details
		@address = Address.find(@order.address_id)
		@payment = Payment.find(@order.payment_id)
    mail(to: @user.email, subject: "[MonsterCoffee] Order# #{order.id} cancelled")
	end

end
