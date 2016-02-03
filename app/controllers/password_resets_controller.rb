class PasswordResetsController < ApplicationController
  before_filter :signed_user, only: :edit

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_password_reset
      redirect_to root_url, :notice => "Email sent with password reset instructions."
    else
      flash.now[:error] = "Sorry. User with '#{params[:email]}' email does not exist"
      render :new
    end
  end

  def edit
    if @user.password_reset_sent_at < 30.minutes.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    end
  end

  def update
    @user = User.find_by_password_reset_token!(params[:password_reset_token])
    if @user.update_attributes(password_params)
      sign_in @user
      redirect_to root_url, :notice => "Password has been update!"
    else
      render :edit
    end
  end

  private
#####################################################################################################################

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Before filters.

  def signed_user
    @user = User.find_by_password_reset_token(params[:password_reset_token])
    redirect_to edit_user_path(@user) unless !current_user?(@user)
  end
end
