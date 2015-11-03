require 'rails_helper'

RSpec.describe "Users API", type: :api do
  let!(:user) { create(:user_with_team) }
  let(:team) { user.teams.first }

  before do
    create_list(:user, 3).map do |user|
      team.team_users.create(user: user)
    end
  end

  describe "GET /api/v1/users" do
    it "returns the current teams users" do
      get "/api/v1/users", {}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:users].size).to eq(4)
    end
  end
end
