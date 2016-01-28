class UserMailer < ActionMailer::Base
  default from: "sampleapp@post.dom"

  def confirm_mail(user)
    @user = user
    mail(to: @user.email, subject: "Wellcome to Sample Application!!")
  end

  def new_follower_mail(follower, followed)
    @follower = follower
    @followed = followed
    mail(to: @followed.email, subject: "#{@follower.name} is following you now in Sample Application.")
  end
end
