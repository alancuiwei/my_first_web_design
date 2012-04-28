require 'test_helper'

class TradeinfoControllerTest < ActionController::TestCase
  test "should get todayinfo" do
    get :todayinfo
    assert_response :success
  end

end
