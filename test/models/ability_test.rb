require "test_helper"

describe Ability, :model do
  let(:ability) { Ability.new(user) }
  let(:other) { create(:user, role: "user") }
  let(:other_admin) { create(:user, role: "admin") }

  describe "users" do
    let(:user) { create(:user, role: "user") }

    it "allows interacting with self" do
      assert ability.can?(:read, user)
      assert ability.can?(:update, user)
    end

    it "disallows interacting with others" do
      assert ability.cannot?(:read, other)
      assert ability.cannot?(:update, other)
      assert ability.cannot?(:create, User)
    end

    it "disallows dangerous settings" do
      assert ability.cannot?(:update, Settings)
    end

    it "allows creation of content" do
      assert ability.can?(:create, Project)
      assert ability.can?(:create, Story)
      assert ability.can?(:create, Attachment)
      assert ability.can?(:create, Task)
    end

    it "allows updating of owned content" do
      [:project, :task, :story, :attachment].each do |content_item|
        assert ability.can?(:update, build(content_item, owner: user))
        assert ability.cannot?(:update, build(content_item, owner: other))
      end
    end

    describe "when user is a member of a project" do
      let(:project) { create(:project, owner: user) }

      before do
        project.users << user
      end

      it "allows viewing of project" do
        assert ability.can?(:read, project)
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
    let(:user) { create(:user, role: "admin") }

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
      owner = create(:user, role: "owner")
      assert ability.cannot?(:create, owner)
    end

    it "can manage overall settings" do
      assert ability.can?(:update, Settings)
    end
  end

  describe "owner" do
    let(:user) { create(:user, role: "owner") }

    it "can do all the things" do
      assert ability.can?(:manage, :all)
      assert ability.can?(:update, Settings)
    end
  end
end
