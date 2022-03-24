class Address < ApplicationRecord
	include Hashid::Rails
	hashid_config pepper: "addresses"

	validates :user_id, {presence: true, on:[:create, :update]}
	validates :receiver, {presence: true, length: { maximum: 20  }, on:[:create, :update]}
	validates :phone_number, {presence: true, format: { with: /\A\d{2,4}-\d{2,4}-\d{4}\z/, message: "Phone Number must be valid" }, on:[:create, :update]}
	validates :post_code, {presence: true, format: { with: /\A\d{3}\-?\d{4}\z/, message: "Post Code must be valid" }, on:[:create, :update]}
	validates :prefecture_id, {presence: true, on:[:create, :update]}
	validates :city, {presence: true, on:[:create, :update]}
	validates :detail, {presence: true, length: { maximum: 100  }, on:[:create, :update]}

	belongs_to :user

	attr_accessor :user_hashid

	def user_hashid
		self.user_hashid = self.user.hashid
	end

	def wrap_json_address
		return self.as_json(methods: [:hashid, :user_hashid], except:[:id, :user_id, :created_at, :updated_at])
	end

end