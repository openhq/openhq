require "test_helper"

describe SetupController do
  it "should get new" do
    get :new
    assert_response :success
  end

  it "should get create" do
    skip("pending")
    post :create
    assert_response :success
  end

end
