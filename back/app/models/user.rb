class User < ApplicationRecord
	include Hashid::Rails
	hashid_config pepper: "users"
	# after_find :reset_id

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

	def wrap_json_user
		return self.as_json(methods: :hashid, except:[:id, :created_at, :updated_at])
	end

	def admin?
		is_admin
	end

	# def reset_id
	# end

end
