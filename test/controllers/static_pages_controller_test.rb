require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  def setup
    @genric_title = "| Insert Generic title to the left"
  end
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Home #{@genric_title}"

  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help #{@genric_title}"
  end

  test 'should get about' do
    get :about
    assert_response :success
    assert_select "title", "About #{@genric_title}"
  end

end
