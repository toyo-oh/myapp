class UsersController < ApplicationController

  before_action :require_login, only: [:index]
  before_action :get_user_with_auth_check, only: [:show, :update, :destroy, :update_email, :update_profile, :update_password]
  wrap_parameters :user, include: [:name, :password, :password_confirmation, :email, :is_admin]
  
  def current_user
    if decoded_token.present?
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
      render json: {user: @user}
    else
      response_unauthorized
    end
  end

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if !@user.save!
      render response_unprocessable_entity(@user.errors)
    else
      UserMailer.welcome_email(@user).deliver_now
    end
  end

  # GET /users/1
  def show
    @user = get_user_with_auth_check
    render json: {user: @user}
  end

  # PATCH/PUT /users/1
  def update
    @current_user = get_user_with_auth_check
    if @current_user.update!(name: params[:name], email: params[:email])
      render json: @current_user
    else
      render response_unprocessable_entity(@current_user.errors)
    end
  end

  # DELETE /users/1
  def destroy
    @user = get_user_with_auth_check
    if !@user.destroy!
      render response_unprocessable_entity(@user.errors)
    end
  end

  # POST /users/1/email
  def update_email
    @user = get_user_with_auth_check
		if @user.email == params[:current_email] && @user.authenticate(params[:password])
      if @user.update!(email: params[:new_email])
        render json: @user
      else
        render response_unprocessable_entity(@user.errors)
      end
		else
			response_unauthorized
		end
  end

  # POST /users/1/profile
  def update_profile
    @user = get_user_with_auth_check
      if @user.update!(name: params[:name], phone_number: params[:phone_number])
        render json: @user
      else
        render response_unprocessable_entity(@user.errors)
      end
  end

  # POST /users/1/psw
  def update_password
    @user = get_user_with_auth_check
		if @user.email == params[:email] && @user.authenticate(params[:current_password])
      if @user.update!(password: params[:new_password], password_confirmation: params[:confirm_password])
        render json: @user
      else
        render response_unprocessable_entity(@user.errors)
      end
		else
			response_unauthorized
		end
  end

  def forget_password
    @user = User.find_by(email: params[:email])
    if !@user.present?
      return render json: {error: 'Email address not found. Please check and try again.'}
    else
      @token = @user.to_sgid(purpose: 'password reset', expires_in: 15.minutes)
      UserMailer.reset_password(@user, @token).deliver_now
    end
  end

  def reset_password
    @user = User.find_signed!(params[:token].to_s, purpose: "password reset")
    # rescue ActiveSupport::MessageVerifier::InvalidSignature
    if !@user.present?
      return render json: {error: 'Your token has been expired, please try again'}
    else
      if @user.update!(password: params[:new_password], password_confirmation: params[:confirm_password])
        render json: @user
      else
        render response_unprocessable_entity(@user.errors)
      end
    end
  end

  def render_reset_password
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email, :is_admin)
    end

    def get_user_with_auth_check
			if validate_user.blank?
					response_unauthorized
			else
				@user = User.find(params[:id])
				if validate_user.id == @user.id
					return @user
				else
					response_unauthorized
				end
			end
		end
end
