class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  attr_accessor :product_hashid

  def product_hashid
    self.product_hashid = product.hashid
  end
end
