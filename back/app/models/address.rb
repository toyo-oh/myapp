class Address < ApplicationRecord
	validates :user_id, {presence: true}
	validates :receiver, {presence: true, length: { maximum: 10  }}
	validates :phone_number, {presence: true, format: { with: /^\d{2,4}-\d{2,4}-\d{4}$/, message: "Phone Number must be valid" }}
	validates :post_code, {presence: true, format: { with: /^[0-9]{3}-[0-9]{4}$/, message: "Post Code must be valid" }}
	validates :detail_address, {presence: true, length: { maximum: 100  }}

end
