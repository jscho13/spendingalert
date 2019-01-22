# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  default from: 'info@spendingalert.com'

  def signed_up_email(user)
    @user = user
    mail(to: ['info@spendingalert.com','jimbutler27@hotmail.com','jscho13@gmail.com'],
    subject: 'SpendingAlert - New User Alert')
  end
end
