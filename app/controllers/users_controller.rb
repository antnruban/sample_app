class UsersController < ApplicationController
  before_action :signed_in_user,  only: [:index, :edit, :update, :destroy, :following, :followers, :search]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy
  before_action :registered_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.confirm_mail(@user).deliver
      flash[:success] = "Email was send to #{@user.email}, you need to confirm your account."
      redirect_to root_path
    else
      render 'new'
    end
  end

  def index
    @users = User.paginate(:page => params[:page])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Your profile updated successfully"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.admin?
      redirect_to users_path, notice: "Can't delete admin account."
    else
      user.destroy
      flash[:success] = "User profile deleted"
      redirect_to users_path
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success] = "Welcome to the Sample App! Your email has been confirmed. Please sign in to continue."
      redirect_to signin_path
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_path
    end
  end

  def unsubscribe
    if user = User.read_access_token(params[:signature])
      user.unsubscribe_user
      render text: "You have been unsubscribed successfully!"
    else
      render text: "Invalid Link"
    end
  end

  def search
    if params[:search_query].present?
      @users = User.search_user(params[:search_query]).paginate(:page => params[:page])
    else
      @users = User.paginate(:page => params[:page])
    end
  end

  # Relationships helpers.

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  private
#####################################################################################################################

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Before filters.

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def registered_user
    redirect_to root_path, notice: "You already have account." unless current_user?(@user)
  end
end
