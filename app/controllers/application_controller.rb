class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  private
    # Require users to login to an account(unless logged in already) in order to edit account
    #
    # Store url which caused this method to execute, once logged in
    # user can be redirected back to forwarding url
    def logged_in_user
      unless logged_in?
        store_forwarding_url # store url which caused this method to execute
        flash[:danger] = "Please login to execute action"
        redirect_to login_path
      end
    end
end
