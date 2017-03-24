require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get letsencrypt" do
    get :letsencrypt
    assert_response :success
  end

end
