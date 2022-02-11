class Product < ApplicationRecord
  validates :title, {presence: true, length: { maximum: 20 }}
	validates :description, {presence: true, length: { maximum: 100 }}
	validates :price, {presence: true, numericality: { greater_than: 0, less_than_or_equal_to:99999999 }}
	validates :quantity, {presence: true, numericality: { greater_than: 0, less_than_or_equal_to:99999999 }}

	mount_uploaders :images, ImageUploader
end
