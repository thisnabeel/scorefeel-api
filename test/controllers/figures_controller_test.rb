require "test_helper"

class FiguresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get figures_index_url
    assert_response :success
  end

  test "should get show" do
    get figures_show_url
    assert_response :success
  end

  test "should get create" do
    get figures_create_url
    assert_response :success
  end

  test "should get update" do
    get figures_update_url
    assert_response :success
  end

  test "should get destroy" do
    get figures_destroy_url
    assert_response :success
  end
end
