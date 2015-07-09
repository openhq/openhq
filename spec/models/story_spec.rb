require 'rails_helper'

RSpec.describe Story do
  let(:story) { build(:story) }

  it "must be valid" do
    expect(story).to be_valid
  end

  describe "#collaborators" do
    let!(:owner) { create(:user) }
    let!(:other_users) { create_list(:user, 3) }
    let!(:story) { create(:story, owner: owner) }

    before do
      create(:comment, commentable: story, owner: other_users[0], content: "Hello there.")
      create(:comment, commentable: story, owner: other_users[1], content: "Hello there.")
      create(:comment, commentable: story, owner: other_users[2], content: "Hello there.")
    end

    context "when the owner has not commented" do
      it "finds all commenters" do
        other_users.each do |user|
          expect(story.collaborators.include?(user)).to be(true)
        end
      end

      it "adds in the owner" do
        expect(story.collaborators.include?(owner)).to be(true)
      end
    end

    context "when the owner has commented" do
      before do
        create(:comment, commentable: story, owner: owner, content: "Hey guise!")
      end

      it "finds all commenters" do
        other_users.each do |user|
          expect(story.collaborators.include?(user)).to be(true)
        end

        expect(story.collaborators.include?(owner)).to be(true)
      end
    end
  end
end
