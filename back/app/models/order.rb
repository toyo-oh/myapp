class Order < ApplicationRecord
  # enum aasm_state: [:order_placed, :paid, :shipping, :shipped, :order_cancelled, :good_returned]
	has_many :order_details, dependent: :destroy
  belongs_to :user

	def create_detail_item(product, quantity, price, remark, image)
		di = order_details.build
		di.product_id = product.id
		di.product_title = product.title
		di.price = price
		di.quantity = quantity
		di.discount = product.discount
		di.subtotal = price * di.quantity
		di.remark = remark
    di.image = image
		di.save!
	end

	def pay!
		self.update_columns(is_paid: true)
	end

  def set_deliver_at!
    self.update_columns(deliver_at: DateTime.now)   
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

    event :ship, after_commit: :set_deliver_at! do
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
