class UserMailer < ApplicationMailer
  default from: 'service@cf.com'
 
  def welcome_email(user)
    @user = user
    @url  = 'http://monstercoffee.com/login'
    mail(to: @user.email, subject: 'Welcome to Monster Coffee Site')
  end

  def reset_password(user, token)
    @user = user
    @token = token
    mail(to: @user.email, subject: '[MonsterCoffee]Password Reset')
  end
end
