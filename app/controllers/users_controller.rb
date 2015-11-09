class UsersController < ApplicationController

  attr_accessor :user

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # User saved
    else
      render 'new'
    end
  end
end
