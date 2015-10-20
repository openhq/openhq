require 'rails_helper'

RSpec.describe "Tasks API", type: :api do
  let!(:user) { create(:user_with_team) }
  let!(:assigned_user) { create(:user) }
  let(:team) { user.teams.first }
  let!(:project) { create(:project, team: team) }
  let!(:story) { create(:story, project: project, team: team, owner: user) }
  let!(:task) { create(:task, project: project, story: story, team: team, owner: user, assignment: assigned_user) }

  describe "GET /api/v1/projects/:project_id/stories/:story_id/tasks" do
    it "lists all tasks" do
      get "/api/v1/projects/#{project.slug}/stories/#{story.slug}/tasks", {}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:tasks].first[:label]).to eq(task.label)
    end
  end

  describe "GET /api/v1/projects/:project_id/stories/:story_id/tasks/:id" do
    it "retrieves a single task" do
      get "/api/v1/projects/#{project.slug}/stories/#{story.slug}/tasks/#{task.id}", {}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:task][:label]).to eq(task.label)
    end
  end

  describe "POST /api/v1/projects/:project_id/stories/:story_id/tasks" do
    context "when input is valid" do
      it "creates a task" do
        task_params = { task: { label: "Buy Milk" } }
        post "/api/v1/projects/#{project.slug}/stories/#{story.slug}/tasks", task_params, api_token_header(user)
        expect(last_response.status).to eq(201)
        expect(response_json[:task][:label]).to eq("Buy Milk")
      end
    end

    context "when input is invalid" do
      it "returns errors" do
        task_params = { task: { label: "" } }
        post "/api/v1/projects/#{project.slug}/stories/#{story.slug}/tasks", task_params, api_token_header(user)
        expect(last_response.status).to eq(422)
      end
    end
  end

  describe "PATCH /api/v1/projects/:project_id/stories/:story_id/tasks/:id" do
    context "when updating completion state" do
      it "marks tasks as complete" do
        task.update(completed: false)
        task_params = { task: { completed: true } }
        patch "/api/v1/projects/#{project.slug}/stories/#{story.slug}/tasks/#{task.id}", task_params, api_token_header(user)
        expect(last_response.status).to eq(200)
        expect(response_json[:task][:completed]).to eq(true)
        expect(task.reload.completed).to be(true)
        expect(task.reload.completed_by).to eq(user.id)
      end

      it "marks tasks as incomplete" do
        task.update(completed: true)
        task_params = { task: { completed: false } }
        patch "/api/v1/projects/#{project.slug}/stories/#{story.slug}/tasks/#{task.id}", task_params, api_token_header(user)
        expect(last_response.status).to eq(200)
        expect(response_json[:task][:completed]).to eq(false)
        expect(task.reload.completed).to be(false)
      end
    end

    context "when input is valid" do
      it "updates the task" do
        task_params = { task: { label: "Buy Milk" } }
        patch "/api/v1/projects/#{project.slug}/stories/#{story.slug}/tasks/#{task.id}", task_params, api_token_header(user)
        expect(last_response.status).to eq(200)
        expect(response_json[:task][:label]).to eq("Buy Milk")
      end
    end

    context "when input is invalid" do
      it "returns errors" do
        task_params = { task: { label: "" } }
        patch "/api/v1/projects/#{project.slug}/stories/#{story.slug}/tasks/#{task.id}", task_params, api_token_header(user)
        expect(last_response.status).to eq(422)
      end
    end
  end

  describe "DELETE /api/v1/projects/:project_id/stories/:story_id/tasks/:id" do
    it "deletes the task" do
      delete "/api/v1/projects/#{project.slug}/stories/#{story.slug}/tasks/#{task.id}", {}, api_token_header(user)
      expect(last_response.status).to eq(204)
      expect(last_response.body).to be_blank
    end
  end
end
