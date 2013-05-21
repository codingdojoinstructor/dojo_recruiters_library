require 'test_helper'

class RecruitersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get request_renew" do
    get :request_renew
    assert_response :success
  end

end
