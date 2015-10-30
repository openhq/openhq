require 'rails_helper'

RSpec.describe "Comments API", type: :api do
  let!(:user) { create(:user_with_team) }
  let!(:assigned_user) { create(:user) }
  let(:team) { user.teams.first }
  let!(:project) { create(:project, team: team) }
  let!(:story) { create(:story, project: project, team: team, owner: user) }
  let!(:comment) { create(:comment, commentable: story, team: team, owner: user) }

  describe "GET /api/v1/comments" do
    it "shows all comments" do
      get "/api/v1/comments", { story_id: story.slug }, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:comments].first[:content]).to eq(comment.content)
    end

    it "paginates and filters comments"
  end

  describe "GET /api/v1/comments/:id" do
    it "returns a single comment" do
      get "/api/v1/comments/#{comment.id}", {}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:comment][:content]).to eq(comment.content)
    end
  end

  describe "POST /api/v1/comments" do
    context "when input is valid" do
      before do
        comment_params = { comment: { content: "**Hello** world", story_id: story.slug } }
        post "/api/v1/comments", comment_params, api_token_header(user)
      end

      it "creates a comment" do
        expect(last_response.status).to eq(201)
        expect(response_json[:comment][:content]).to eq("**Hello** world")
      end

      it "supports markdown" do
        expect(response_json[:comment][:markdown]).to eq("<p><strong>Hello</strong> world</p>")
      end
    end

    context "when input is invalid" do
      it "returns errors" do
        comment_params = { comment: { content: "", story_id: story.slug } }
        post "/api/v1/comments", comment_params, api_token_header(user)
        expect(last_response.status).to eq(422)
      end
    end
  end

  describe "PATCH /api/v1/comments/:id" do
    context "when input is valid" do
      it "updates the comment" do
        comment_params = { story_id: story.slug, comment: { content: "Hello world" } }
        patch "/api/v1/comments/#{comment.id}", comment_params, api_token_header(user)
        expect(last_response.status).to eq(200)
        expect(response_json[:comment][:content]).to eq("Hello world")
      end
    end

    context "when input is invalid" do
      it "returns errors" do
        comment_params = { comment: { content: "" }, story_id: story.slug }
        patch "/api/v1/comments/#{comment.id}", comment_params, api_token_header(user)
        expect(last_response.status).to eq(422)
      end
    end
  end

  describe "DELETE /api/v1/comments/:id" do
    it "deletes the comment" do
      delete "/api/v1/comments/#{comment.id}", {}, api_token_header(user)
      expect(last_response.status).to eq(204)
      expect(last_response.body).to be_blank
    end
  end
end
