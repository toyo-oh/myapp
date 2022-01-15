class Address < ApplicationRecord
	validates :user_id, presence: true
	validates :receiver, presence: true
	validates :receiver, length: { maximum: 10  }
	validates :phone_number, presence: true
	validates :phone_number, format: { with: /^\d{2,4}-\d{2,4}-\d{4}$/, message: "Phone Number must be valid" }
	validates :post_code, presence: true
	validates :post_code, format: { with: /^[0-9]{3}-[0-9]{4}$/, message: "Post Code must be valid" }
	validates :detail_address, presence: true
	validates :detail_address, length: { maximum: 100  }

end
