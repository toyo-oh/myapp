class Product < ApplicationRecord
	has_many :reviews

  validates :title, {presence: true, length: { maximum: 20 }}
	validates :sub_title, {presence: true, length: { maximum: 50 }}
	validates :category_id, {presence: true}
	validates :description, {presence: true, length: { maximum: 300 }}
	validates :price, {presence: true, numericality: { greater_than: 0, less_than_or_equal_to:99999999 }}
	validates :quantity, {presence: true, numericality: { greater_than: 0, less_than_or_equal_to:99999999 }}

	mount_uploaders :images, ImageUploader
end
