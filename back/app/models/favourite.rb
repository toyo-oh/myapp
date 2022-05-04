class Favourite < ApplicationRecord
  include Hashid::Rails
  hashid_config pepper: 'favourites'

  belongs_to :user
  belongs_to :product
  attr_accessor :user_hashid, :product_hashid

  def user_hashid
    self.user_hashid = user.hashid
  end

  def product_hashid
    self.product_hashid = product.hashid
  end

  def wrap_json_favourite
    as_json(methods: %i[hashid user_hashid product_hashid],
            except: %i[id user_id product_id created_at updated_at])
  end
end
