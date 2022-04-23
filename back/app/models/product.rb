class Product < ApplicationRecord
	include Hashid::Rails
	hashid_config pepper: "products"

	has_many :reviews
	has_many :promotions
	has_many :favourites

  validates :title, {presence: true, length: { maximum: 10 }}
	validates :sub_title, {presence: true, length: { maximum: 50 }}
	validates :category_id, {presence: true}
	validates :description, {presence: true, length: { maximum: 300 }}
	validates :price, {presence: true, numericality: { greater_than: 0, less_than_or_equal_to:99999999 }}
	validates :quantity, {presence: true, numericality: {less_than_or_equal_to:99999999 }}

	mount_uploaders :images, ImageUploader


	def wrap_json_product
		return self.as_json(methods: :hashid, except:[:id, :created_at, :updated_at])
	end

end
