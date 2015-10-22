require 'rails_helper'

RSpec.describe "Search API", type: :api do
  let!(:user) { create(:user_with_team) }
  let!(:project) { create(:project, name: "Test Project", team: user.teams.first) }
  let!(:story) { create(:story, name: "Test Story", project: project, team: user.teams.first, owner: user) }

  before do
    project.users << user
  end

  describe "POST /api/v1/search" do
    it "returns results" do
      post "/api/v1/search", { term: "Test" }, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:search].count).to be(2)
    end

    it "limits the results and includes meta" do
      post "/api/v1/search", { term: "Test", limit: 1 }, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:search].count).to be(1)
    end

    it "includes meta data" do
      post "/api/v1/search", { term: "Test", limit: 1, page: 1 }, api_token_header(user)
      expect(response_json[:meta][:next_url]).to include('page=2')
      expect(response_json[:meta][:next_url]).to include('term=Test')
      expect(response_json[:meta][:next_url]).to include('limit=1')
      expect(response_json[:meta][:total]).to be(2)
      expect(response_json[:meta][:term]).to eq("Test")
    end

    it "doesnt have a next_url if there no more results" do
      post "/api/v1/search", { term: "Test", limit: 1, page: 2 }, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:meta][:next_url]).to be_nil
    end

    it "returns an empty array when there are no results" do
      post "/api/v1/search", { term: "gobbledygook" }, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:search].count).to be(0)
    end

    it "returns an error when there is no term" do
      post "/api/v1/search", {}, api_token_header(user)
      expect(last_response.status).to eq(422)
    end
  end
end