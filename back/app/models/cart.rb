class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items, source: :product
  belongs_to :user

  def add_product_to_cart(product, _user_id)
    ci = cart_items.build
    ci.product_id = product.id
    ci.price = product.price
    ci.quantity = 1
    ci.save!
  end
end
