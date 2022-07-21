class UsersController < ApplicationController
  before_action :require_login, only: [:index]
  before_action :auth_check,
                only: %i[show update destroy update_email update_profile update_password]
  wrap_parameters :user, include: %i[name password password_confirmation email is_admin]

  def current_user
    if !validate_user.blank?
      @user = validate_user
      render json: { user: @user.wrap_json_user }
    else
      response_custom_error('error', 'account or password is incorrect')
    end
  end

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # POST /users
  def create
    @user = User.find_by(email: params[:email])
    unless @user.present?
      @user = User.new(user_params)
      render response_unprocessable_entity(@user.errors) unless @user.save!
    end
    @token = @user.signed_id(purpose: 'activate account', expires_in: 30.minutes)
    UserMailer.activate_account(@user, @token).deliver_later
    render json: { code: 'ok', message: 'account activation mail has been sent, please check!' }
  end

  def activate_account
    @user = User.find_signed(params[:token], purpose: 'activate account')
    if !@user.present?
      render json: { code: 'error', message: 'your token has been expired, please try again' }
    elsif @user.update!(is_activated: true)
      render json: { code: 'ok', message: 'account activate successfully, please login!' }
    else
      render response_unprocessable_entity(@user.errors)
    end
  end

  def render_activate_account; end

  # GET /users/1
  def show
    @user = auth_check
    render json: { user: @user.wrap_json_user }
  end

  # PATCH/PUT /users/1
  def update
    @current_user = auth_check
    if @current_user.update!(name: params[:name], email: params[:email])
      render json: { code: 'ok', message: 'updated user info successfully!', user: @current_user.wrap_json_user }
    else
      render response_unprocessable_entity(@current_user.errors)
    end
  end

  # DELETE /users/1
  def destroy
    @user = auth_check
    if !@user.destroy!
      render response_unprocessable_entity(@user.errors)
    else
      render json: { code: 'ok', message: 'deleted user info successfully!' }
    end
  end

  # POST /users/1/update_email
  def update_email
    @user = auth_check
    if @user.email == params[:current_email] && @user.authenticate(params[:password])
      if @user.update!(email: params[:new_email])
        render json: { code: 'ok', message: 'updated email successfully, please re-login with new email!',
                       user: @user.wrap_json_user }
      else
        render response_unprocessable_entity(@user.errors)
      end
    else
      response_unauthorized
    end
  end

  # POST /users/1/update_profile
  def update_profile
    @user = auth_check
    if @user.update!(name: params[:name], phone_number: params[:phone_number])
      render json: { code: 'ok', message: 'updated profile successfully!', user: @user.wrap_json_user }
    else
      render response_unprocessable_entity(@user.errors)
    end
  end

  # POST /users/1/update_password
  def update_password
    @user = auth_check
    if @user.email == params[:email] && @user.authenticate(params[:current_password])
      if @user.update!(password: params[:new_password], password_confirmation: params[:confirm_password])
        render json: { code: 'ok', message: 'updated password successfully, please re-login with new password!',
                       user: @user.wrap_json_user }
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
      render json: { code: 'error', message: 'email address not found. please check and try again.' }
    else
      @token = @user.signed_id(purpose: 'password reset', expires_in: 15.minutes)
      UserMailer.reset_password(@user, @token).deliver_later
      render json: { code: 'ok', message: 'password reset mail has been sent, please check!',
                     user: @user.wrap_json_user }
    end
  end

  def reset_password
    @user = User.find_signed(params[:token], purpose: 'password reset')
    if !@user.present?
      render json: { code: 'error', message: 'your token has been expired, please try again.' }
    elsif @user.update!(password: params[:new_password], password_confirmation: params[:confirm_password])
      render json: { code: 'ok', message: 'reset password successfully!', user: @user.wrap_json_user }
    else
      render response_unprocessable_entity(@user.errors)
    end
  end

  def render_reset_password; end

  private

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :email, :is_admin)
  end

  def auth_check
    if validate_user.blank?
      response_unauthorized
    else
      @user = if params[:id].blank?
                User.find(params[:hashid])
              else
                User.find(params[:id])
              end
      if validate_user.id == @user.id
        @user
      else
        response_unauthorized
      end
    end
  end
end
