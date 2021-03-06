class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy, :following, :followers] # want users to login before following actions
  before_action :correct_user, only: [:edit, :update] # ensure only user can edit own profile
  before_action :admin_user, only: [:destroy] # ensure only admin can execute destroy action

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
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

  def destroy
    @user = User.find(params[:id])
    name = @user.name
    @user.destroy
    flash[:success] = "You destroyed #{name}"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find_by(id: params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follows'
  end

  def followers
    @title = "Followers"
    @user = User.find_by(id: params[:id])
    @users = @user.followers.paginate(page:  params[:page])
    render 'show_follows'
  end

  private

    # only the following params maybe processed, this prevents users from setting admin: true
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end

    def correct_user
      @user = User.find_by(id: params[:id])
      redirect_to root_url unless @user == current_user
    end
end
