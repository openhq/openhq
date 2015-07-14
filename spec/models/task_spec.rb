require 'rails_helper'

RSpec.describe Task do
  let(:task) { build(:task) }

  it { should belong_to(:story) }
  it { should belong_to(:owner).class_name("User") }
  it { should belong_to(:assignment).class_name("User") }
  it { should belong_to(:completer).class_name("User") }

  it { should validate_presence_of(:label) }
  it { should validate_presence_of(:story_id) }

  it "must be valid" do
    expect(task).to be_valid
  end

  describe "#assignment_name" do
    context "when unassigned" do
      it "returns unassigned" do
        task = build(:task, assignment: nil)

        expect(task.assignment_name).to eq("unassigned")
      end
    end

    context "when assigned" do
      it "returns the assignees username" do
        user = build(:user, username: "harry2003")
        task = build(:task, assignment: user)

        expect(task.assignment_name).to eq("harry2003")
      end
    end
  end

  describe "#update_completion_status" do
    it "sets a task as completed" do
      task = create(:task)

      task.update_completion_status(true, create(:user, username: "harry2006"))

      expect(task.completer.username).to eq("harry2006")
      expect(task.completed?).to be(true)
      expect(task.completed_on).to be_within(10.seconds).of(Time.zone.now)
    end
  end
end
