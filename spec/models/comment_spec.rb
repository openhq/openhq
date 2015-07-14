require 'rails_helper'

RSpec.describe Comment do
  let(:comment) { build(:comment) }

  it { should belong_to(:commentable) }
  it { should belong_to(:owner).class_name("User") }
  it { should have_many(:attachments) }

  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:owner_id) }

  it "must be valid" do
    expect(comment).to be_valid
  end
end
