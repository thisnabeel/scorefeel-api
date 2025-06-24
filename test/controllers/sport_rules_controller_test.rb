require "test_helper"

class SportRulesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sport_rules_index_url
    assert_response :success
  end

  test "should get show" do
    get sport_rules_show_url
    assert_response :success
  end

  test "should get create" do
    get sport_rules_create_url
    assert_response :success
  end

  test "should get update" do
    get sport_rules_update_url
    assert_response :success
  end

  test "should get destroy" do
    get sport_rules_destroy_url
    assert_response :success
  end
end
