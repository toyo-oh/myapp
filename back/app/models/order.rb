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
    self.user_hashid = user.hashid
  end

  def wrap_json_order
    as_json(methods: :user_hashid, except: %i[id payment_id address_id user_id updated_at])
  end

  def create_detail_item(cart_item, remark, image, order_no)
    di = order_details.build
    di.order_no = order_no
    di.product_id = cart_item.product.id
    di.product_title = cart_item.product.title
    di.price = cart_item.price
    di.quantity = cart_item.quantity
    di.discount = cart_item.product.discount
    di.subtotal = cart_item.price * di.quantity
    di.remark = remark
    di.image = image
    di.property = cart_item.product.property
    di.save!
  end

  def pay!(customer_id, charge_id, last4)
    update_columns(is_paid: true, customer_id: customer_id, charge_id: charge_id, last4: last4)
    make_payment!
  end

  def refund!(refund_id)
    update_columns(refund_id: refund_id)
    cancel!
  end

  def set_deliver_info!(slug, tracking_number)
    update_columns(slug: slug, tracking_number: tracking_number, deliver_at: DateTime.now)
  end

  include AASM
  aasm do
    state :order_placed, initial: true
    state :paid
    state :shipping
    state :delivered
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
      transitions from: :paid, to: :shipping
    end

    event :deliver do
      transitions from: :shipping, to: :delivered
    end

    # event :return_good do
    #   transitions from: :shipping,      to: :delivered
    # end

    event :cancel do
      transitions from: %i[order_placed paid], to: :order_cancelled
    end
  end
end
