require 'rails_helper'

RSpec.describe "User API", type: :api do
  let!(:user) { create(:user_with_team) }

  describe "GET /api/v1/user" do
    context "when unauthenticated" do
      it "returns an authentication error" do
        get "/api/v1/user"
        expect(last_response.status).to eq(401)
      end
    end

    context "when signed in" do
      it "returns the current users information" do
        get "/api/v1/user", {}, api_token_header(user)
        expect(response_json[:data][:id]).to eq(String(user.id))
        expect(response_json[:data][:attributes].keys).to include(:display_name, :first_name, :last_name, :username, :email, :notification_frequency, :last_notified_at, :job_title, :avatar_url, :created_at, :updated_at)
      end
    end
  end

  describe "POST /api/v1/user" do
    it "allows first time user account creation"
  end

  describe "PUT /api/v1/user" do
    it "allows the user to update their profile"
  end

  describe "DELETE /api/v1/user" do
    it "allows the user to delete their account"
  end
end
