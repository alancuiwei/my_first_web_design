require 'test_helper'

class StrategyControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get performance" do
    get :performance
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get config" do
    get :config
    assert_response :success
  end

end
