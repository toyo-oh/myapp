class User < ApplicationRecord
	validates :email, {presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email must be valid" }, on:[:create, :update_email]}
	validates :name, {presence: true, length: { maximum: 10}, on:[:create, :update_profile]}
	validates :password, {presence: true, length: { in: 6..20 }, confirmation: true, on:[:create, :update_password]}
	validates :password_confirmation, {presence: true, length: { in: 6..20 }, on:[:create, :update_password]}

	# has_secure_token
	has_secure_password
	has_one :cart
	has_many :addresses
	has_many :payments
	has_many :reviews
	has_many :orders

	def admin?
		is_admin
	end

end
