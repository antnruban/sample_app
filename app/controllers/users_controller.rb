class UsersController < ApplicationController
  before_action :signed_in_user, only:  [:index, :edit, :update, :destroy]
  before_action :correct_user, only:    [:edit, :update]
  before_action :admin_user, only:      :destroy
  before_action :registered_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
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

  private
#######################################################################################################################

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Before filters.

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please, sign in."
    end
  end

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
