class AuthenticationsController < UsersController

	skip_before_action :require_login, only: :create

	def create
		user = User.find_by(email: params[:email])
		if user && user.authenticate(params[:password])
			expired = (Time.now + 1.hours).to_i
			payload = { user_id: user.id, email: user.email, expired: expired }
			token = encode_token(payload)
			render json: { jwt: token, message: "logged in successfully!" }
		else
			response_custom_error("error", "account or password is incorrect")
		end
	end
end
