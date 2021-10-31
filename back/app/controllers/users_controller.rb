class UsersController < ApplicationController

  SECRET_KEY_BASE = Rails.application.credentials.secret_key_base
  before_action :require_login, :set_user, only: [:show, :update, :destroy]
  # FOR ERROR! [Password can't be blank in Rails (Using has_secure_password)]
  # https://stackoverflow.com/questions/30632639/password-cant-be-blank-in-rails-using-has-secure-password
  # TODO wrap_parameters
  wrap_parameters :user, include: [:name, :password, :password_confirmation, :email, :is_admin]

  def require_login
    response_unauthorized if current_user.blank?
  end

  def current_user
    if decoded_token.present?
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
      render json: {data: @user}
    else
      render json: {status: 401, message: 'user not exist!'}
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

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  # ******* NOT IN USE ******* 
  def login
    current_user = User.find_by(email: params[:email], password: params[:password])
    if current_user.nil?
      render json: {status: 401, message: 'login failed!'}
    else
      render json: {token: current_user.token}
    end
  end

    # ******* NOT IN USE ******* 
  def find_user_by_token
    tokenB = request.headers["Authorization"]
    token = tokenB[7,tokenB.length-7]
    current_user = User.find_by(token: token)
    if current_user.nil?
      render json: {status: 401, message: 'user not exist!'}
    else
      render json: {data: current_user}
    end
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

    def auth_header
      request.headers['Authorization']
    end
end
