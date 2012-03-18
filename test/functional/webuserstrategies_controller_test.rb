require 'test_helper'

class WebuserstrategiesControllerTest < ActionController::TestCase
  setup do
    @webuserstrategy = webuserstrategy(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:webuserstrategy)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create webuserstrategy" do
    assert_difference('Webuserstrategy.count') do
      post :create, webuserstrategy: @webuserstrategy.attributes
    end

    assert_redirected_to webuserstrategy_path(assigns(:webuserstrategy))
  end

  test "should show webuserstrategy" do
    get :show, id: @webuserstrategy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @webuserstrategy
    assert_response :success
  end

  test "should update webuserstrategy" do
    put :update, id: @webuserstrategy, webuserstrategy: @webuserstrategy.attributes
    assert_redirected_to webuserstrategy_path(assigns(:webuserstrategy))
  end

  test "should destroy webuserstrategy" do
    assert_difference('Webuserstrategy.count', -1) do
      delete :destroy, id: @webuserstrategy
    end

    assert_redirected_to webuserstrategies_path
  end
end
