class Payment < ApplicationRecord
	include Hashid::Rails
	hashid_config pepper: "payments"

	validates :user_id, {presence: true}
	validates :holder_name, {presence: true, length: { maximum: 20 }}
	validates :card_number, {presence: true, format: { with: /\A\d{16}\z/, message: "Card Number must be valid" }}
	validates :expiration_date, {presence: true, format: { with: /\A\d{6}\z/, message: "Expiration Date must be valid" }}
	validates :security_code, {presence: true, format: { with: /\A\d{3}\z/, message: "Security Code must be valid" }}

	belongs_to :user

	attr_accessor :user_hashid

	def user_hashid
		self.user_hashid = self.user.hashid
	end

	def wrap_json_payment
		return self.as_json(methods: [:hashid, :user_hashid], except:[:id, :user_id, :created_at, :updated_at])
	end
end
