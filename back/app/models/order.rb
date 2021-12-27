class Order < ApplicationRecord
	has_many :order_details, dependent: :destroy

	def create_detail_item(product, quantity, remark)
		di = order_details.build
		di.product_id = product.id
		di.product_title = product.title
		di.price = product.price
		di.quantity = quantity
		di.discount = 1
		di.subtotal = di.price * di.discount * di.quantity
		di.remark = remark
		di.save
	end

end
