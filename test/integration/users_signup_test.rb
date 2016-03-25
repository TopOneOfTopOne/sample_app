require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test 'does not submit data with wrong input' do
    get signup_path # this is not needed but useful to check if everything render correctly
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                               email: "invalidemail@invalid",
                               password: "as",
                               password_confirmation: "as" }
    end
  end

  test 'submit data with correct input' do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { # post_via_redirect follows the redirect
        name: "jackson",
        email: "email@email.com",
        password: "wordsa1",
        password_confirmation: "wordsa1"
      }
      assert_template 'users/show' # assert the rendered template is indeed the show view
    end
  end

end
