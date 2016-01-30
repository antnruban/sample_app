class UserMailer < ActionMailer::Base
  after_action :prevent_delivery_to_followed, only: :new_follower_mail
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

  private
#######################################################################################################################

  def prevent_delivery_to_followed
    message.perform_deliveries = false if @followed.email_subscribed == false
  end
end
