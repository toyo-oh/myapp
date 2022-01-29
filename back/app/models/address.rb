class Address < ApplicationRecord
	validates :user_id, {presence: true}
	validates :receiver, {presence: true, length: { maximum: 20  }}
	validates :phone_number, {presence: true, format: { with: /\A\d{2,4}-\d{2,4}-\d{4}\z/, message: "Phone Number must be valid" }}
	validates :post_code, {presence: true, format: { with: /\A\d{3}\-?\d{4}\z/, message: "Post Code must be valid" }}
	validates :detail_address, {presence: true, length: { maximum: 100  }}

	belongs_to :user
end
