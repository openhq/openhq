require 'rails_helper'
require 'vcr_helper'

RSpec.describe "Attachments API", type: :api do
  let!(:user) { create(:user_with_team) }
  let(:team) { user.teams.first }
  let!(:project) { create(:project, team: team) }
  let!(:story) { create(:story, project: project, team: team, owner: user) }
  let!(:attachment) { create(:attachment, story: story, project: project, team: team, owner: user) }

  describe "GET /api/v1/attachments" do
    it "returns the attachments" do
      get "/api/v1/attachments", { story_id: story.slug }, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:attachments].first[:name]).to eq(attachment.name)
    end
  end

  describe "GET /api/v1/attachments/presigned_upload_url" do
    it "returns a presigned s3 url to upload to" do
      get "/api/v1/attachments/presigned_upload_url", {
        file_name: "boss.jpg",
        file_type: "image/jpeg"
        }, api_token_header(user)
      expect(last_response.status).to eq(201)
      expect(response_json[:upload_url]).not_to be_empty
    end
  end

  describe "GET /api/v1/attachments/:id" do
    it "returns the attachment" do
      get "/api/v1/attachments/#{attachment.id}", {}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:attachment]).not_to be_empty
    end
  end

  describe "POST /api/v1/attachments" do
    context "when input is valid" do
      it "creates an attachment" do
        attachment_params = {
          story_id: story.slug,
          attachment: {
            name: "Map",
            file_name: "map.jpg",
            file_path: "uploads/images/map.jpg",
            file_size: 1012324,
            content_type: "image/jpg"
          }
        }
        post "/api/v1/attachments", attachment_params, api_token_header(user)
        expect(last_response.status).to eq(201)
        expect(response_json[:attachment]).not_to be(nil)
        expect(response_json[:attachment][:file_name]).to eq("map.jpg")
      end
    end

    context "when input is invalid" do
      it "returns errors" do
        attachment_params = {
          story_id: story.slug,
          attachment: {
            name: "",
            file_name: "",
            file_path: ""
          }
        }
        post "/api/v1/attachments", attachment_params, api_token_header(user)
        expect(last_response.status).to eq(422)
      end
    end
  end

  describe "PATCH /api/v1/attachments/:id" do
    context "when input is valid" do
      it "updates the attachment" do
        attachment_params = { attachment: { name: "Turbo" } }
        patch "/api/v1/attachments/#{attachment.id}", attachment_params, api_token_header(user)
        expect(last_response.status).to eq(200)
        expect(response_json[:attachment][:name]).to eq("Turbo")
      end
    end

    context "when input is invalid" do
      it "returns errors" do
        attachment_params = { attachment: { file_path: "" } }
        patch "/api/v1/attachments/#{attachment.id}", attachment_params, api_token_header(user)
        expect(last_response.status).to eq(422)
      end
    end
  end

  describe "DELETE /api/v1/attachments/:id" do
    it "destroys the attachment" do
        delete "/api/v1/attachments/#{attachment.id}", {}, api_token_header(user)
        expect(last_response.status).to eq(204)
        expect(last_response.body).to be_empty
    end
  end
end
