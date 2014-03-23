require 'test_helper'

class FundTransfersControllerTest < ActionController::TestCase
  test "should get success" do
    get :success
    assert_response :success
  end

  test "should get failed" do
    get :failed
    assert_response :success
  end

end
