require 'rails_helper'

RSpec.describe "Stories API", type: :api do
  let!(:user) { create(:user_with_team) }
  let(:team) { user.teams.first }
  let!(:project) { create(:project, team: team) }
  let!(:story) { create(:story, project: project, team: team, owner: user) }

  describe "GET /api/v1/stories" do
    it "lists all stories for the project" do
      get "/api/v1/stories", { project_id: project.id }, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:stories].first[:name]).to eq(story.name)
    end

    it "paginates and filters"
  end

  describe "GET /api/v1/stories/:id" do
    it "displays the story" do
      get "/api/v1/stories/#{story.slug}", {}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:story][:name]).to eq(story.name)
    end
  end

  describe "POST /api/v1/stories" do
    context "when input is valid" do
      it "creates a story" do
        story_params = {
          project_id: project.id,
          story: {
            name: "Hiyas",
            description: "What about ye"
          }
        }

        post "/api/v1/stories", story_params, api_token_header(user)
        expect(last_response.status).to eq(201)
        expect(response_json[:story][:name]).to eq("Hiyas")
      end
    end

    context "when input is invalid" do
      it "returns errors" do
        story_params = {
          project_id: project.id,
          story: {
            description: "What about ye"
          }
        }

        post "/api/v1/stories", story_params, api_token_header(user)
        expect(last_response.status).to eq(422)
      end
    end
  end

  describe "PATCH /api/v1/stories/:id" do
    context "when input is valid" do
      it "updates the story" do
        story_params = { story: { name: "Hiyas" } }

        patch "/api/v1/stories/#{story.slug}", story_params, api_token_header(user)
        expect(last_response.status).to eq(200)
        expect(response_json[:story][:name]).to eq("Hiyas")
      end
    end

    context "when input is invalid" do
      it "returns errors" do
        story_params = { story: { name: "" } }

        patch "/api/v1/stories/#{story.slug}", story_params, api_token_header(user)
        expect(last_response.status).to eq(422)
      end
    end
  end

  describe "DELETE /api/v1/stories/:id" do
    it "deletes the story" do
      delete "/api/v1/stories/#{story.slug}", {}, api_token_header(user)
      expect(last_response.status).to eq(204)
      expect(last_response.body).to be_blank
    end
  end

  describe "GET /api/v1/stories/:id/collaborators" do
    it "fetches the collaborators" do
      get "/api/v1/stories/#{story.id}/collaborators", {}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:users].first[:id]).to eq(user.id)
    end
  end
end
