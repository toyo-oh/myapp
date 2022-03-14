class Product < ApplicationRecord
	has_many :reviews
	has_many :promotions

  validates :title, {presence: true, length: { maximum: 10 }}
	validates :sub_title, {presence: true, length: { maximum: 25 }}
	validates :category_id, {presence: true}
	validates :description, {presence: true, length: { maximum: 300 }}
	validates :price, {presence: true, numericality: { greater_than: 0, less_than_or_equal_to:99999999 }}
	validates :quantity, {presence: true, numericality: {less_than_or_equal_to:99999999 }}

	mount_uploaders :images, ImageUploader
end
