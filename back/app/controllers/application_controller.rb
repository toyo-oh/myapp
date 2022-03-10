class ApplicationController < ActionController::API
  
  SECRET_KEY_BASE = Rails.application.credentials.secret_key_base
	# rescue_from StandardError, with: :response_internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :response_page_not_found
  
  def response_admin_unauthorized
    render status: 401, json: { status: 401, message: 'Admin Unauthorized' }
  end

  def response_unauthorized(message)
    message = 'Unauthorized' if message.blank? 
    render status: 401, json: { status: 401, message: message }
  end

  def response_internal_server_error
    render status: 500, json: { status: 500, message: 'Internal Server Error' }
  end

  def response_page_not_found
    render status: 404, json: { status: 404, message: 'Page is not found' }
  end

  def response_unprocessable_entity(errors)
    render status: unprocessable_entity, json: { status: unprocessable_entity, message: errors }
  end

  def require_login
    response_unauthorized if validate_user.blank?
  end

  def require_admin
    response_admin_unauthorized if !validate_user.admin?
  end

  def validate_user
    if decoded_token.present?
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def encode_token(payload)
    JWT.encode payload, SECRET_KEY_BASE, 'HS256'
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode token, SECRET_KEY_BASE, true, { algorithm: 'HS256' }
      rescue JWT::DecodeError
        []
      end
    end
  end

  private
    def auth_header
      request.headers['Authorization']
    end

end