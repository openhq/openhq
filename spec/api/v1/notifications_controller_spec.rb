require 'rails_helper'

RSpec.describe "Notifications API", type: :api do
  let!(:user) { create(:user_with_team) }
  let(:team) { user.teams.first }

  let!(:unseen_notifications) { create_list(:notification, 3, user: user, team: team, notifiable_type: "Task", action_performed: "created", seen: false) }
  let!(:seen_notifications) { create_list(:notification, 3, user: user, team: team, seen: true) }

  describe "GET /api/v1/notifications" do
    it "shows all notifications" do
      get "/api/v1/notifications", {}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:notifications].count).to eq(6)
    end

    it "limits the results" do
      get "/api/v1/notifications", { limit: 4 }, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:notifications].count).to eq(4)
    end

    it "gets the selected page" do
      get "/api/v1/notifications", { limit: 4, page: 2 }, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:notifications].count).to eq(2)
    end

    it "returns the meta data" do
      get "/api/v1/notifications", { limit: 4 }, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:meta][:total]).to eq(6)
      expect(response_json[:meta][:has_more]).to eq(true)
      expect(response_json[:meta][:next_url]).to include('page=2')
      expect(response_json[:meta][:next_url]).to include('limit=4')
    end
  end

  describe "GET /api/v1/notifications/unseen" do
    it "returns all the unseen notification" do
      get "/api/v1/notifications/unseen", {}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:notifications].count).to eq(3)
    end

    it "can include seen notifications" do
      get "/api/v1/notifications/unseen", { include_seen: 1 }, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:notifications].count).to eq(6)
    end

    it "can still limit the number of notifications" do
      get "/api/v1/notifications/unseen", { include_seen: 1, min_limit: 5 }, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:notifications].count).to eq(5)
    end
  end

  describe "GET /api/v1/notifications/:id" do
    it "can get a single notification" do
      get "/api/v1/notifications/#{unseen_notifications.first.id}", {}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:notification][:action_performed]).to eq("task_created")
    end
  end

  describe "PUT /api/v1/notifications/mark_all_seen" do
    it "marks all notifications as seen" do
      get "/api/v1/notifications/unseen", {}, api_token_header(user)
      expect(response_json[:notifications].count).to eq(3)
      put "/api/v1/notifications/mark_all_seen", {}, api_token_header(user)
      get "/api/v1/notifications/unseen", {}, api_token_header(user)
      expect(response_json[:notifications].count).to eq(0)
    end
  end

  describe "PUT /api/v1/notifications/mark_as_seen" do
    it "marks given notifications as seen" do
      get "/api/v1/notifications/unseen", {}, api_token_header(user)
      expect(response_json[:notifications].count).to eq(3)
      put "/api/v1/notifications/mark_as_seen", {ids: [unseen_notifications.first.id]}, api_token_header(user)
      get "/api/v1/notifications/unseen", {}, api_token_header(user)
      expect(response_json[:notifications].count).to eq(2)
    end
  end
end
