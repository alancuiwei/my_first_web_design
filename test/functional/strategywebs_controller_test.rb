require 'test_helper'

class StrategywebsControllerTest < ActionController::TestCase
  setup do
    @strategyweb = strategyweb(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:strategyweb)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create strategyweb" do
    assert_difference('Strategyweb.count') do
      post :create, strategyweb: @strategyweb.attributes
    end

    assert_redirected_to strategyweb_path(assigns(:strategyweb))
  end

  test "should show strategyweb" do
    get :show, id: @strategyweb
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @strategyweb
    assert_response :success
  end

  test "should update strategyweb" do
    put :update, id: @strategyweb, strategyweb: @strategyweb.attributes
    assert_redirected_to strategyweb_path(assigns(:strategyweb))
  end

  test "should destroy strategyweb" do
    assert_difference('Strategyweb.count', -1) do
      delete :destroy, id: @strategyweb
    end

    assert_redirected_to strategywebs_path
  end
end
