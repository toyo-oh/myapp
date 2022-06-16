class UserMailer < ApplicationMailer
  default from: 'monstercf.service@gmail.com'

  def activate_account(user, token)
    @user = user
    @token = token
    @url = 'https://monstercf.net/login'
    mail(to: @user.email, subject: '【MonsterCoffee】Account Activation')
  end

  def reset_password(user, token)
    @user = user
    @token = token
    mail(to: @user.email, subject: '【MonsterCoffee】Password Reset')
  end
end
