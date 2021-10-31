class ApplicationController < ActionController::API

	rescue_from Exception, with: :response_internal_server_error
  
  def response_unauthorized
    render status: 401, json: { status: 401, message: 'Unauthorized' }
  end

  def response_internal_server_error
    render status: 500, json: { status: 500, message: 'Internal Server Error' }
  end
end