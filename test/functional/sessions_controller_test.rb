require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get request_renew" do
    get :request_renew
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

end
