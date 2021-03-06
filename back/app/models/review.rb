class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user
  attr_accessor :user_hashid, :product_hashid

  def product_hashid
    self.product_hashid = product.hashid
  end

  def user_hashid
    self.user_hashid = user.hashid
  end
end
