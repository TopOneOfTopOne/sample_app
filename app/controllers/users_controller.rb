class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

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
      log_in(@user)
      flash[:success] = "Welcome to my first app #{@user.name}"
      redirect_to @user # equivalent to redirect_to user_url(@user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @user.update_attributes(user_params)
    if @user.save
      flash[:success] = "Updated Profile!"
      redirect_to @user
    else
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

  # Require users to login to an account(unless logged in already) in order to edit account
  #
  # Store url which caused this method to execute, once logged in
  # user can be redirected back to forwarding url
    def logged_in_user
      unless logged_in?
        store_forwarding_url # store url which caused this method to execute
        flash[:danger] = "Please login to edit your account"
        redirect_to login_path
      end
    end

    def correct_user
      @user = User.find_by(id: params[:id])
      redirect_to root_url unless @user == current_user
    end
end
