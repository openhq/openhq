require 'rails_helper'

RSpec.describe "Tasks API", type: :api do
  let!(:user) { create(:user_with_team) }
  let!(:assigned_user) { create(:user) }
  let(:team) { user.teams.first }
  let!(:project) { create(:project, team: team) }
  let!(:story) { create(:story, project: project, team: team, owner: user) }
  let!(:task) { create(:task, project: project, story: story, team: team, owner: user, assignment: assigned_user) }

  describe "GET /api/v1/tasks" do
    it "lists all tasks" do
      get "/api/v1/tasks", { story_id: story.slug }, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:tasks].first[:label]).to eq(task.label)
    end
  end

  describe "GET /api/v1/tasks/me" do
    before do
      user.tasks.create!(label: "Buy milk", due_at: Time.zone.now - 1.day, story: story, team: team)
      user.tasks.create!(label: "Buy printer ink", due_at: Time.zone.now, story: story, team: team)
      user.tasks.create!(label: "Send invoices", due_at: Time.zone.now + 3.days, story: story, team: team)
      user.tasks.create!(label: "Feed the fish", story: story, team: team)
    end

    it "lists tasks assigned to me" do
      get "/api/v1/tasks/me", {}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:overdue].first[:label]).to eq("Buy milk")
      expect(response_json[:today].first[:label]).to eq("Buy printer ink")
      expect(response_json[:this_week].first[:label]).to eq("Send invoices")
      expect(response_json[:other].first[:label]).to eq("Feed the fish")
    end
  end

  describe "GET /api/v1/tasks/:id" do
    it "retrieves a single task" do
      get "/api/v1/tasks/#{task.id}", {}, api_token_header(user)
      expect(last_response.status).to eq(200)
      expect(response_json[:task][:label]).to eq(task.label)
    end
  end

  describe "POST /api/v1/tasks" do
    context "when input is valid" do
      it "creates a task" do
        task_params = { task: { label: "Buy Milk", story_id: story.slug } }
        post "/api/v1/tasks", task_params, api_token_header(user)
        expect(last_response.status).to eq(201)
        expect(response_json[:task][:label]).to eq("Buy Milk")
      end
    end

    context "when input is invalid" do
      it "returns errors" do
        task_params = { task: { label: "", story_id: story.slug} }
        post "/api/v1/tasks", task_params, api_token_header(user)
        expect(last_response.status).to eq(422)
      end
    end
  end

  describe "PATCH /api/v1/tasks/:id" do
    context "when updating completion state" do
      it "marks tasks as complete" do
        task.update(completed: false)
        task_params = { task: { completed: true } }
        patch "/api/v1/tasks/#{task.id}", task_params, api_token_header(user)
        expect(last_response.status).to eq(200)
        expect(response_json[:task][:completed]).to eq(true)
        expect(task.reload.completed).to be(true)
        expect(task.reload.completed_by).to eq(user.id)
      end

      it "marks tasks as incomplete" do
        task.update(completed: true)
        task_params = { task: { completed: false } }
        patch "/api/v1/tasks/#{task.id}", task_params, api_token_header(user)
        expect(last_response.status).to eq(200)
        expect(response_json[:task][:completed]).to eq(false)
        expect(task.reload.completed).to be(false)
      end
    end

    context "when input is valid" do
      it "updates the task" do
        task_params = { task: { label: "Buy Milk" } }
        patch "/api/v1/tasks/#{task.id}", task_params, api_token_header(user)
        expect(last_response.status).to eq(200)
        expect(response_json[:task][:label]).to eq("Buy Milk")
      end
    end

    context "when input is invalid" do
      it "returns errors" do
        task_params = { task: { label: "" } }
        patch "/api/v1/tasks/#{task.id}", task_params, api_token_header(user)
        expect(last_response.status).to eq(422)
      end
    end
  end

  describe "DELETE /api/v1/tasks/:id" do
    it "deletes the task" do
      delete "/api/v1/tasks/#{task.id}", {}, api_token_header(user)
      expect(last_response.status).to eq(204)
      expect(last_response.body).to be_blank
    end
  end

  describe "PUT /api/v1/projects/:project_id/stories/:story_id/tasks/order" do
    it "sets the order of tasks"
  end

  describe "DELETE /api/v1/projects/:project_id/stories/:story_id/tasks/completed" do
    it "deletes all completed tasks"
  end
end
