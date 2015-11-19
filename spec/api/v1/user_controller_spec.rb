require 'rails_helper'

RSpec.describe "User API", type: :api do
  let!(:user) { create(:user_with_team, password: "abcd1234") }

  describe "GET /api/v1/user" do
    context "when unauthenticated" do
      it "returns an authentication error" do
        get "/api/v1/user"
        expect(last_response.status).to eq(401)
      end
    end

    context "when signed in" do
      it "returns the current users information" do
        get "/api/v1/user", {}, api_token_header(user)
        expect(response_json[:user][:id]).to eq(user.id)
        expect(response_json[:user].keys).to include(:id, :display_name, :first_name, :last_name, :username, :email, :notification_frequency, :last_notified_at, :job_title, :avatar_url, :created_at, :updated_at)
      end
    end
  end

  describe "POST /api/v1/user" do
    it "allows first time user account creation"
  end

  describe "PUT /api/v1/user" do
    it "allows the user to update their profile" do
      user_params = {current_password:"abcd1234", username:"father_ted"}
      put "/api/v1/user", {user:user_params}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:user][:id]).to eq(user.id)
      expect(response_json[:user][:username]).to eq('father_ted')
    end

    it "requires the current password to update" do
      user_params = {username:"father_ted"}
      put "/api/v1/user", {user:user_params}, api_token_header(user)
      expect(last_response.status).to eq(422)
      expect(response_json[:errors].first[:errors].first).to include('password was incorrect')
    end
  end

  describe "PUT /api/v1/user/password" do
    it "allows the user to update their password" do
      user_params = {current_password:"abcd1234", password: "updatedPassword"}
      put "/api/v1/user/password", {user:user_params}, api_token_header(user)
      expect(last_response.status).to eq(200)

      user_params = {current_password:"updatedPassword", username:"father_ted"}
      put "/api/v1/user", {user:user_params}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:user][:username]).to eq('father_ted')
    end

    it "requires the original password to update" do
      user_params = {current_password:"wrong", password: "updatedPassword"}
      put "/api/v1/user/password", {user:user_params}, api_token_header(user)
      expect(last_response.status).to eq(422)
    end
  end

  describe "DELETE /api/v1/user" do
    it "allows the user to delete their account" do
      delete "/api/v1/user", {current_password: "abcd1234"}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:user][:deleted_at]).not_to be_nil
    end

    it "requires the password to delete" do
      delete "/api/v1/user", {current_password: "wrong"}, api_token_header(user)
      expect(last_response.status).to eq(422)
    end
  end
end
