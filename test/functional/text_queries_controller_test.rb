require 'test_helper'

class TextQueriesControllerTest < ActionController::TestCase
  setup do
    @text_query = text_queries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:text_queries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create text_query" do
    assert_difference('TextQuery.count') do
      post :create, text_query: { response: @text_query.response, text: @text_query.text }
    end

    assert_redirected_to text_query_path(assigns(:text_query))
  end

  test "should show text_query" do
    get :show, id: @text_query
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @text_query
    assert_response :success
  end

  test "should update text_query" do
    put :update, id: @text_query, text_query: { response: @text_query.response, text: @text_query.text }
    assert_redirected_to text_query_path(assigns(:text_query))
  end

  test "should destroy text_query" do
    assert_difference('TextQuery.count', -1) do
      delete :destroy, id: @text_query
    end

    assert_redirected_to text_queries_path
  end
end
