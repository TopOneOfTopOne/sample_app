require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  def setup
    @genric_title = "My first app"
  end
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "#{@genric_title}"

  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | #{@genric_title}"
  end

  test 'should get about' do
    get :about
    assert_response :success
    assert_select "title", "About | #{@genric_title}"
  end

  test 'should get contact' do
    get :contact
    assert_response :success
    assert_select "title", "Contact | #{@genric_title}"
  end

end
