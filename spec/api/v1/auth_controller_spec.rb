require 'rails_helper'

RSpec.describe "Auth API", type: :api do
  let!(:user) { create(:user_with_team, password: "Password1!") }
  let(:team) { user.teams.first }

  describe "POST /api/v1/auth" do
    context "when params are valid" do
      it "returns api token" do
        params = {
          email: user.email,
          password: "Password1!",
          subdomain: team.subdomain
        }

        post "/api/v1/auth", params
        expect(last_response.status).to eq(200)
        expect(response_json[:api_token]).to include(:token)
      end
    end

    context "when params are invalid" do
      it "returns auth failed" do
        params = {
          email: user.email,
          password: "incorrect-password",
          subdomain: team.subdomain
        }

        post "/api/v1/auth", params
        expect(last_response.status).to eq(401)
        expect(last_response.body).to include("Access denied")
      end
    end
  end
end
