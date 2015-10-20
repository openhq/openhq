require 'rails_helper'

describe "GET /api/v1/projects", type: :api do
  context "when signed out" do
    it "returns auth failed" do
      get "/api/v1/projects"
      expect(last_response.status).to eq(401)
      expect(response_json[:message]).to eq("Authentication Required")
    end
  end

  context "when signed in" do
    let!(:user) { create(:user_with_team) }
    let!(:project) { create(:project, team: user.teams.first) }

    before do
      project.users << user
    end

    it "returns the users projects" do
      get "/api/v1/projects", {}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:projects].first[:name]).to eq(project.name)
    end
  end
end

describe "POST /api/v1/projects", type: :api do
  context "when params are valid" do
    let!(:user) { create(:user_with_team) }

    it "creates a new project" do
      project_params = {
        project: {
          name: "Accounting"
        }
      }
      post "/api/v1/projects", project_params, api_token_header(user)
      expect(last_response.status).to eq(201)
      expect(response_json[:project][:name]).to eq("Accounting")
    end
  end

  context "when params are invalid" do
    let!(:user) { create(:user_with_team) }

    it "creates a new project" do
      project_params = { project: { name: "" } }
      post "/api/v1/projects", project_params, api_token_header(user)
      expect(last_response.status).to eq(422)
      expect(response_json[:message]).to eq("Validation Failed")
      expect(response_json[:errors].first).to eq("Name can't be blank")
    end
  end
end
