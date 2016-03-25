class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    # Add "debugger" method to pause execution and inspect what is going on # method included from byebug gem
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to my first app #{@user.name}"
      redirect_to @user # equivalent to redirect_to user_url(@user)
    else
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
