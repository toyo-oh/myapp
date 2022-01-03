class User < ApplicationRecord
	# has_secure_token
	has_secure_password
	has_one :cart

	def admin?
		is_admin
	end
	
end
