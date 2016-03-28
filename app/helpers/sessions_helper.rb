module SessionsHelper

  # session and cookies are methods but behave much like hashes

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def forget(user)
    user.forget # set digest token to nil in database

    # remove cookie information from client browser
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Returns the current logged in user but returns nil when:
  # - client browser cookie token is different to the token stored in database for the given user id
  # - no such user id exists in database
  #
  # Log in user if permanent session i.e. use of cookies. Because user maybe
  # opening from new browser session, hence they must be logged in
  # if they opted for permanent session.
  #
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
    user.remember # generate and add new digest token to database

    # send cookie information to browser
    #
    # user id is encrypted
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def redirect_back_or(default)
    redirect_to session[:forwarding_url] || default
    session.delete(:forwarding_url) # critical, otherwise subsequent calls will redirect incorrectly
  end

  private

    # Only GET requests since they are the only valid urls users can submit in browser
    def store_forwarding_url
      session[:forwarding_url] = request.url if request.get?
    end
end
