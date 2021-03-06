class User < ApplicationRecord
  include Hashid::Rails
  hashid_config pepper: 'users'

  validates :email,
            { presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be valid' },
              on: %i[create update_email] }
  validates :name, { presence: true, length: { maximum: 10 }, on: %i[create update_profile] }
  validates :password, { presence: true, length: { in: 6..20 }, confirmation: true, on: %i[create update_password] }
  validates :password_confirmation, { presence: true, length: { in: 6..20 }, on: %i[create update_password] }

  # has_secure_token
  has_secure_password
  has_one :cart
  has_many :addresses
  has_many :payments
  has_many :reviews
  has_many :orders

  def wrap_json_user
    as_json(methods: :hashid, except: %i[id password_digest created_at updated_at])
  end

  def admin?
    is_admin
  end
end
