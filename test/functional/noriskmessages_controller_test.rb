require 'test_helper'

class NoriskmessagesControllerTest < ActionController::TestCase
  setup do
    @noriskmessage = noriskmessage(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:noriskmessage)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create noriskmessage" do
    assert_difference('Noriskmessage.count') do
      post :create, noriskmessage: @noriskmessage.attributes
    end

    assert_redirected_to noriskmessage_path(assigns(:noriskmessage))
  end

  test "should show noriskmessage" do
    get :show, id: @noriskmessage.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @noriskmessage.to_param
    assert_response :success
  end

  test "should update noriskmessage" do
    put :update, id: @noriskmessage.to_param, noriskmessage: @noriskmessage.attributes
    assert_redirected_to noriskmessage_path(assigns(:noriskmessage))
  end

  test "should destroy noriskmessage" do
    assert_difference('Noriskmessage.count', -1) do
      delete :destroy, id: @noriskmessage.to_param
    end

    assert_redirected_to noriskmessages_path
  end
end
