class Payment < ApplicationRecord
	validates :user_id, {presence: true}
	validates :holder_name, {presence: true, length: { maximum: 20 }}
	validates :card_number, {presence: true, format: { with: /\A\d{16}\z/, message: "Card Number must be valid" }}
	validates :expiration_date, {presence: true, format: { with: /\A\d{6}\z/, message: "Expiration Date must be valid" }}
	validates :security_code, {presence: true, format: { with: /\A\d{3}\z/, message: "Security Code must be valid" }}

	belongs_to :user
end
