class SessionsController < ApplicationController
  def new
  end

  # Creates a new user session with cookies if remember_me checkbox is selected
  # otherwise the session only lasts as long as the browser is open
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or current_user
    else
      flash.now[:danger] = "Invalid password/email combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
