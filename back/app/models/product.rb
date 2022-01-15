class Product < ApplicationRecord
    validates :title, presence: true
    validates :title, length: { maximum: 20  }
	validates :description, presence: true
    validates :description, length: { maximum: 100  }
	validates :price, presence: true
    validates :price,  numericality: { greater_than: 0, less_than_or_equal_to:99999999 }
	validates :quantity, presence: true
    validates :quantity, numericality: { greater_than: 0, less_than_or_equal_to:99999999 }

    mount_uploader :image, ImageUploader
end
