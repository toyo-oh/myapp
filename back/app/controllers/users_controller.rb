class UsersController < ApplicationController

  before_action :require_login, only: [:index]
  before_action :get_user_with_auth_check, only: [:show, :update, :destroy]
  # https://stackoverflow.com/questions/30632639/password-cant-be-blank-in-rails-using-has-secure-password
  # https://qiita.com/kazutosato/items/fbaa2fc0443611c627fc
  # https://stackoverflow.com/questions/50641705/how-do-you-use-rails-5-2-wrap-parameters
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
    if !@user.save
      render response_unprocessable_entity(@user.errors)
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
    if @current_user.update(name: params[:name], email: params[:email])
      render json: @current_user
    else
      render response_unprocessable_entity(@current_user.errors)
    end
  end

  # DELETE /users/1
  def destroy
    @user = get_user_with_auth_check
    if !@user.destroy
      render response_unprocessable_entity(@user.errors)	
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
