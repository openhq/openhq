require 'rails_helper'

RSpec.describe "Mentions API", type: :api do
  let!(:user) { create(:user_with_team, username: "freddy") }
  let(:team) { user.teams.first }

  describe "GET /api/v1/mentions/users" do
    before do
      bobby = create(:user, username: "bobby")
      team.team_users.create!(user: bobby)
      frank = team.invite({email: "frank.wells@example.org"}, user)

      get "/api/v1/mentions/users", {}, api_token_header(user)
    end

    it "returns successfully" do
      expect(last_response.status).to eq(200)
    end

    it "ignores users without a username" do
      expect(response_json.first[:username]).to eq("freddy")
      expect(response_json.size).to eq(2)
    end
  end

  describe "GET /api/v1/mentions/emojis" do
    it "returns emojis" do
      get "/api/v1/mentions/emojis", {}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json.first).to eq("smile")
    end
  end
end
