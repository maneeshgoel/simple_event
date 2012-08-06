class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.save
    redirect_to user_path(@user)
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "user updated!"
      redirect_to user_path(@user)
    else
      flash[:error] = "couldn't update user!"
      redirect_to user_path(@user)
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end
end
