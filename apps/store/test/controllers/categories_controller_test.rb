require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  setup do
    @category = categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:categories)
  end

  test "should create category" do
    assert_difference('Category.count') do
      post :create, category: { name: @category.name }
    end

    assert_response 201
  end

  test "should show category" do
    get :show, id: @category
    assert_response :success
  end

  test "should update category" do
    put :update, id: @category, category: { name: @category.name }
    assert_response 204
  end

  test "should destroy category" do
    assert_difference('Category.count', -1) do
      delete :destroy, id: @category
    end

    assert_response 204
  end
end
