require "test_helper"

class SportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sports_index_url
    assert_response :success
  end

  test "should get show" do
    get sports_show_url
    assert_response :success
  end

  test "should get create" do
    get sports_create_url
    assert_response :success
  end

  test "should get update" do
    get sports_update_url
    assert_response :success
  end

  test "should get destroy" do
    get sports_destroy_url
    assert_response :success
  end
end
