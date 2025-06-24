require "test_helper"

class PicturesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pictures_index_url
    assert_response :success
  end

  test "should get show" do
    get pictures_show_url
    assert_response :success
  end

  test "should get create" do
    get pictures_create_url
    assert_response :success
  end

  test "should get update" do
    get pictures_update_url
    assert_response :success
  end

  test "should get destroy" do
    get pictures_destroy_url
    assert_response :success
  end

  test "should get generate_pictures" do
    get pictures_generate_pictures_url
    assert_response :success
  end
end
