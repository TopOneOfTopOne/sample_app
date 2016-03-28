ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use! # makes output tests fancierrM

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  # helper methods are not available to tests so we need to define them here
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user, options={})
    if integration_test?
      password = options[:password] || 'password'
      remember_me = options[:remember_me] || '1'
      post login_path, session: { email:       user.email,
                                  password:    password,
                                  remember_me: remember_me }
    else
      session[user_id] = user.id
    end
  end

  private
    def integration_test?
      defined?(post_via_redirect) # post_via_redirect method only available in integration testing
    end
end
