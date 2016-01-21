class UserMailer < ActionMailer::Base
  default from: "sampleapp@post.dom"

  def welcome_mail(user)
    @user = user
    mail(to: @user.email, subject: "Wellcome to Sample Application!!")
  end
end
