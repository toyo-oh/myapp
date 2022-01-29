class User < ApplicationRecord
	validates :email, {presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email must be valid" }}
	validates :name, {presence: true, length: { maximum: 10}}
	validates :password, {presence: true, length: { in: 6..20 }, confirmation: true}
	validates :password_confirmation, {presence: true, length: { in: 6..20 }}

	# has_secure_token
	has_secure_password
	has_one :cart
	has_many :addresses
	has_many :payments

	def admin?
		is_admin
	end

end
