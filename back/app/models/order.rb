class Order < ApplicationRecord
  # enum status: { order_placed: 0, paid: 1, shipping: 2, shipped: 3, order_cancelled: 4, good_returned: 5}
  # enum aasm_state: [:order_placed, :paid, :shipping, :shipped, :order_cancelled, :good_returned]
  before_create :generate_order_no
	has_many :order_details, dependent: :destroy
  belongs_to :user
  attr_accessor :user_hashid
  
  def generate_order_no
    self.order_no = SecureRandom.uuid
  end

	def user_hashid
		self.user_hashid = self.user.hashid
	end

  def wrap_json_order
		return self.as_json(methods: :user_hashid, except:[:id, :payment_id, :address_id, :user_id, :updated_at])
	end

	def create_detail_item(product, quantity, price, remark, image, no)
		di = order_details.build
    di.order_no = no
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

	def pay!(customer_id, charge_id, last4)
		self.update_columns(is_paid: true, customer_id: customer_id, charge_id: charge_id, last4: last4)
    make_payment!
	end

  def set_deliver_info!(slug, tracking_number)
    self.update_columns(slug: slug, tracking_number: tracking_number, deliver_at: DateTime.now)   
  end

	include AASM
  aasm do
    state :order_placed, initial: true
    state :paid
    state :shipping
    state :shipped
    state :order_cancelled
    state :good_returned

    # event :make_payment, after_commit: :pay! do
		# 	transitions from: :order_placed, to: :paid
		# end
    event :make_payment do
			transitions from: :order_placed, to: :paid
		end

    # event :ship, after_commit: :set_deliver_info! do
    #   transitions from: :paid,         to: :shipping
    # end

    event :ship do
      transitions from: :paid,  to: :shipping
    end

    event :deliver do
      transitions from: :shipping,     to: :shipped
    end

    event :return_good do
      transitions from: :shipped,      to: :good_returned
    end

    event :cancel do
      transitions from: [:order_placed, :paid], to: :order_cancelled
    end
  end

end
