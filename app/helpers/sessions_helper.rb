module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def forget(user)
    user.forget # set token to nil in database
    cookies.delete(:user_id) # remove cookie information from client browser
    cookies.delete(:remember_token)
  end

  # Returns the current logged in user if any.
  # log in user if permanent session i.e. use of cookies. Because user maybe opening browser, hence they must be logged in
  # if they opted for permanent session.
  # Storing current user in a variable is good because you do not have as many calls to the database (dubious claim)
  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: user_id) # find cannot be used because it returns and error when :user_id is nil
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end


end
