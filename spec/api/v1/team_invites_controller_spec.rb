require 'rails_helper'

RSpec.describe "Team Invites API", type: :api do
  let!(:user) { create(:user_with_team, email: "owner@openhq.io") }
  let!(:project) { create(:project, name: "Test Project", team: user.teams.first) }
  let!(:other_project) { create(:project, name: "Other Project", team: user.teams.first) }

  before do
    project.users << user
  end

  describe "POST /api/v1/team_invites" do
    it "requires a valid email address" do
      post "/api/v1/team_invites", { user: { email: "invite" } }, api_token_header(user)
      expect(last_response.status).to eq(422)
    end

    it "invites a new user to the team" do
      post "/api/v1/team_invites", { user: { email: "invite@openhq.io" } }, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:user][:team_invites].count).to eq(1)
      expect(response_json[:user][:team_invites].first[:team_id]).to eq(user.teams.first.id)
      expect(response_json[:user][:team_invites].first[:role]).to eq("user")
      expect(response_json[:user][:team_invites].first[:status]).to eq("invited")
      expect(response_json[:user][:team_invites].first[:invitation_code]).not_to be_empty
      expect(response_json[:user][:team_invites].first[:invited_at]).not_to be_empty
      expect(response_json[:user][:team_invites].first[:invited_by]).to eq(user.id)
    end

    it "adds projects to the invited user" do
      post "/api/v1/team_invites", { user: { email: "invite@openhq.io", project_ids: [project.id] } }, api_token_header(user)
      expect(response_json[:user][:projects].first[:id]).to eq(project.id)
    end

    it "does not add projects the current user is not part of" do
      post "/api/v1/team_invites", { user: { email: "invite@openhq.io", project_ids: [project.id, other_project.id] } }, api_token_header(user)
      expect(response_json[:user][:projects].count).to eq(1)
      expect(response_json[:user][:projects].first[:id]).to eq(project.id)
    end

    it "will not invite a user if they are already on the team" do
      post "/api/v1/team_invites", { user: { email: user.email } }, api_token_header(user)
      expect(response_json[:user][:team_invites]).to be_empty
    end

    it "will only invite a user one time" do
      post "/api/v1/team_invites", { user: { email: "invite@openhq.io" } }, api_token_header(user)
      expect(response_json[:user][:team_invites].count).to eq(1)
      post "/api/v1/team_invites", { user: { email: "invite@openhq.io" } }, api_token_header(user)
      expect(response_json[:user][:team_invites].count).to eq(1)
    end

    it "will add projects to an already invited user" do
      post "/api/v1/team_invites", { user: { email: "invite@openhq.io" } }, api_token_header(user)
      expect(response_json[:user][:projects]).to be_empty
      post "/api/v1/team_invites", { user: { email: "invite@openhq.io", project_ids: [project.id] } }, api_token_header(user)
      expect(response_json[:user][:projects]).not_to be_empty
    end
  end

  describe "PUT /api/v1/team_invites/:id" do
    before do
      post "/api/v1/team_invites", { user: { email: "invite@openhq.io" } }, api_token_header(user)
    end

    it "activates an invited user" do
      invite_code = response_json[:user][:team_invites].first[:invitation_code]

      params = {user: {
        first_name: "Fred",
        last_name: "Durst",
        username: "limpbizzy"
      }}

      put "/api/v1/team_invites/#{invite_code}", params, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:user][:team_invites]).to be_empty
      expect(response_json[:user][:team_users].count).to eq(1)
      expect(response_json[:user][:username]).to eq("limpbizzy")
    end

    it "requires validation" do
      invite_code = response_json[:user][:team_invites].first[:invitation_code]

      put "/api/v1/team_invites/#{invite_code}", {user: {first_name: ""}}, api_token_header(user)
      expect(last_response.status).to eq(422)
    end
  end
end
