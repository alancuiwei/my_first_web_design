require 'test_helper'

class ContactusControllerTest < ActionController::TestCase
  test "should get intro" do
    get :intro
    assert_response :success
  end

  test "should get hire" do
    get :hire
    assert_response :success
  end

end
