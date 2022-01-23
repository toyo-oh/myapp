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
		di.save!
	end

	def pay!
		self.update_columns(is_paid: true)
	end

	include AASM
  aasm do
    state :order_placed, initial: true
    state :paid
    state :shipping
    state :shipped
    state :order_cancelled
    state :good_returned

    event :make_payment, after_commit: :pay! do
			transitions from: :order_placed, to: :paid
		end
    # event :make_payment do
		# 	transitions from: :order_placed, to: :paid
		# end

    event :ship do
      transitions from: :paid,         to: :shipping
    end

    event :deliver do
      transitions from: :shipping,     to: :shipped
    end

    event :return_good do
      transitions from: :shipped,      to: :good_returned
    end

    event :cancel_order do
      transitions from: [:order_placed, :paid], to: :order_cancelled
    end
  end

end