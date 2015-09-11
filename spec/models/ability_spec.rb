require "rails_helper"

RSpec.describe Ability do
  let!(:team) { create(:team) }
  let(:ability) { Ability.new(team_user) }

  let(:other) do
    user = create(:user, username: "alfred")
    create(:team_user, role: "user", user: user, team: team)
    user
  end

  let(:other_admin) do
    user = create(:user, username: "frank")
    create(:team_user, role: "admin", user: user, team: team)
    user
  end

  describe "users" do
    let(:user) { create(:user, username: "john") }
    let(:team_user) { create(:team_user, role: "user", user: user, team: team) }

    it "allows interacting with self" do
      assert ability.can?(:read, user)
      assert ability.can?(:update, user)
    end

    it "disallows interacting with others" do
      assert ability.cannot?(:read, other)
      assert ability.cannot?(:update, other)
      assert ability.cannot?(:create, User)
    end

    it "allows creation of content" do
      assert ability.can?(:create, Project)
      assert ability.can?(:create, Story)
      assert ability.can?(:create, Attachment)
      assert ability.can?(:create, Task)
    end

    it "allows updating of owned content" do
      [:project, :task, :story, :attachment, :comment].each do |content_item|
        assert ability.can?(:update, build(content_item, owner: user))
        assert ability.cannot?(:update, build(content_item, owner: other))
      end
    end

    it "allows deletion of owned comments" do
      [:comment, :project].each do |content_item|
        assert ability.can?(:destroy, build(content_item, owner: user))
        assert ability.cannot?(:destroy, build(content_item, owner: other))
      end
    end

    describe "when user is a member of a project" do
      let(:project) { create(:project, owner: user) }
      let(:story) { project.stories.create(name: "My story", owner: other) }

      before do
        project.users << user
      end

      it "allows viewing of project" do
        assert ability.can?(:read, project)
      end

      it "allows archival of stories in that project" do
        assert ability.can?(:destroy, story)
      end
    end

    describe "when user is not a member of a project" do
      let(:project) { create(:project, owner: other) }

      before do
        project.users << other
      end

      it "allows viewing of project" do
        assert ability.cannot?(:read, project)
      end
    end
  end

  describe "admins" do
    let(:user) { create(:user, username: "charlie") }
    let(:team_user) { create(:team_user, role: "admin", user: user, team: team) }

    it "allows assignment of roles" do
      assert ability.can?(:assign_roles, other)
    end

    it "allows management of projects" do
      project = build(:project)
      assert ability.can?(:create, Project)
      assert ability.can?(:update, project)
      assert ability.can?(:destroy, project)
    end

    it "allows edit of users below admin" do
      assert ability.can?(:update, other)
      assert ability.cannot?(:update, other_admin)
    end

    it "cannot create an owner" do
      owner = build(:team_user, role: "owner")
      assert ability.cannot?(:create, owner)
    end
  end

  describe "owner" do
    let(:user) { create(:user, username: "dennis") }
    let(:team_user) { create(:team_user, role: "owner", user: user, team: team) }

    it "can do all the things" do
      assert ability.can?(:manage, :all)
    end
  end
end
