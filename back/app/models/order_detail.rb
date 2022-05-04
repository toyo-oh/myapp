class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product
  attr_accessor :product_hashid

  def product_hashid
    self.product_hashid = product.hashid
  end
end
