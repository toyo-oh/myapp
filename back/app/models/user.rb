class User < ApplicationRecord
	validates :email, uniqueness: true
	validates :email, presence: true,
	validates :email, format: { with: /.+@.+\..+/, message: "Email must be valid" }
	validates :name, presence: true
	validates :name, length: { maximum: 10  }
	validates :password, presence: true
	validates :password, length: { in: 6..20 }
	validates :password, confirmation: true
	validates :password_confirmation, length: { in: 6..20 }
	validates :password_confirmation, presence: true

	# has_secure_token
	has_secure_password
	has_one :cart

	def admin?
		is_admin
	end

end
