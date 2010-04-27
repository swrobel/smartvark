require 'test_helper'

class RedemptionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:redemptions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create redemption" do
    assert_difference('Redemption.count') do
      post :create, :redemption => { }
    end

    assert_redirected_to redemption_path(assigns(:redemption))
  end

  test "should show redemption" do
    get :show, :id => redemptions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => redemptions(:one).to_param
    assert_response :success
  end

  test "should update redemption" do
    put :update, :id => redemptions(:one).to_param, :redemption => { }
    assert_redirected_to redemption_path(assigns(:redemption))
  end

  test "should destroy redemption" do
    assert_difference('Redemption.count', -1) do
      delete :destroy, :id => redemptions(:one).to_param
    end

    assert_redirected_to redemptions_path
  end
end
