require "test_helper"

class FabricationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get fabrications_index_url
    assert_response :success
  end
end
