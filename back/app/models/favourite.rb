class Favourite < ApplicationRecord
	include Hashid::Rails
	hashid_config pepper: "favourites"

	belongs_to :user
	belongs_to :product
	attr_accessor :user_hashid
	attr_accessor :product_hashid

	def user_hashid
		self.user_hashid = self.user.hashid
	end

	def product_hashid
		self.product_hashid = self.product.hashid
	end

	def wrap_json_favourite
		return self.as_json(methods: [:hashid, :user_hashid, :product_hashid], 
			except:[:id, :user_id, :product_id, :created_at, :updated_at])
	end

end
