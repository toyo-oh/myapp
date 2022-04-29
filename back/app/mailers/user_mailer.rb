class UserMailer < ApplicationMailer
  default from: 'service@cf.com'
 
  def activate_account(user, token)
    @user = user
    @token = token
    @url  = 'http://monstercoffee.com/login'
    mail(to: @user.email, subject: '[MonsterCoffee]Account Activation')
  end

  def reset_password(user, token)
    @user = user
    @token = token
    mail(to: @user.email, subject: '[MonsterCoffee]Password Reset')
  end
end
