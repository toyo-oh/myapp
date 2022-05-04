class Promotion < ApplicationRecord
  include Hashid::Rails
  hashid_config pepper: 'products'

  belongs_to :product
  attr_accessor :product_hashid

  def product_hashid
    self.product_hashid = product.hashid
  end
end
