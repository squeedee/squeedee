require 'test_helper'

class Client::AboutControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
