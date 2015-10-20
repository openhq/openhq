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
        expect(response_json[:user][:id]).to eq(user.id)
        expect(response_json[:user].keys).to match_array([:id, :display_name, :first_name, :last_name, :username, :email, :notification_frequency, :last_notified_at, :job_title, :avatar_url, :created_at, :updated_at])
      end
    end
  end
end
