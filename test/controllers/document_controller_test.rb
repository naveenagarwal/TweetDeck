require 'test_helper'

class DocumentControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get document_create_url
    assert_response :success
  end

end
