class Address < ApplicationRecord
  include Hashid::Rails
  hashid_config pepper: 'addresses'

  validates :user_id, { presence: true, on: %i[create update] }
  validates :receiver, { presence: true, length: { maximum: 20 }, on: %i[create update] }
  validates :phone_number,
            { presence: true, format: { with: /\A\d{2,4}-\d{2,4}-\d{4}\z/, message: 'must be valid' },
              on: %i[create update] }
  validates :post_code,
            { presence: true, format: { with: /\A\d{3}-?\d{4}\z/, message: 'must be valid' }, on: %i[create update] }
  validates :prefecture_id, { presence: true, on: %i[create update] }
  validates :city, { presence: true, on: %i[create update] }
  validates :detail, { presence: true, length: { maximum: 100 }, on: %i[create update] }

  belongs_to :user

  attr_accessor :user_hashid

  def user_hashid
    self.user_hashid = user.hashid
  end

  def wrap_json_address
    as_json(methods: %i[hashid user_hashid], except: %i[id user_id created_at updated_at])
  end
end
