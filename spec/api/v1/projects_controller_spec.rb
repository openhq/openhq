require 'rails_helper'

RSpec.describe "Projects API", type: :api do
  let!(:user) { create(:user_with_team) }
  let!(:project) { create(:project, team: user.teams.first) }

  before do
    project.users << user
  end

  describe "GET /api/v1/projects" do
    context "when signed out" do
      it "returns auth failed" do
        get "/api/v1/projects"
        expect(last_response.status).to eq(401)
        expect(last_response.body).to include("Access denied")
      end
    end

    context "when signed in" do
      it "returns the users projects" do
        get "/api/v1/projects", {}, api_token_header(user)
        expect(last_response.status).to eq(200)
        expect(response_json[:projects].first[:name]).to eq(project.name)
      end

      it "includes recent_stories" do
        get "/api/v1/projects", {}, api_token_header(user)
        expect(response_json[:projects].first[:recent_stories]).to be_a(Array)
      end
    end
  end

  describe "GET /api/v1/projects/:slug" do
    context "when user has access to project" do
      it "returns the users projects" do
        get "/api/v1/projects/#{project.slug}", {}, api_token_header(user)
        expect(last_response.status).to eq(200)
        expect(response_json[:project][:name]).to eq(project.name)
      end
    end
  end

  describe "POST /api/v1/projects" do
    context "when params are valid" do
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
      it "returns errors" do
        project_params = { project: { name: "" } }
        post "/api/v1/projects", project_params, api_token_header(user)
        expect(last_response.status).to eq(422)
        expect(response_json[:message]).to eq("Validation Failed")
        expect(response_json[:errors].first[:field]).to eq("name")
        expect(response_json[:errors].first[:errors].first).to eq("can't be blank")
      end
    end
  end

  describe "PATCH /api/v1/projects/:slug" do
    context "when params are valid" do
      it "updates the project" do
        project_params = {
          project: {
            name: "Website V1"
          }
        }
        patch "/api/v1/projects/#{project.slug}", project_params, api_token_header(user)
        expect(last_response.status).to eq(200)
        expect(response_json[:project][:name]).to eq("Website V1")
      end
    end

    context "when params are invalid" do
      it "returns errors" do
        project_params = { project: { name: "" } }
        patch "/api/v1/projects/#{project.slug}", project_params, api_token_header(user)
        expect(last_response.status).to eq(422)
        expect(response_json[:message]).to eq("Validation Failed")
        expect(response_json[:errors].first[:field]).to eq("name")
        expect(response_json[:errors].first[:errors].first).to eq("can't be blank")
      end
    end
  end

  describe "DELETE /api/v1/projects/:slug" do
    it "deletes a project" do
      delete "/api/v1/projects/#{project.slug}", {}, api_token_header(user)
      expect(last_response.status).to eq(204)
      expect(last_response.body).to be_empty

      expect { Project.find(project.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
