require 'test_helper'

class OmniauthSessionControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get omniauth_session_create_url
    assert_response :success
  end

end
