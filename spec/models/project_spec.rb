require 'rails_helper'

RSpec.describe Project do
  let(:project) { build(:project) }

  it "must be valid" do
    expect(project).to be_valid
  end

  it { should belong_to :owner }
  it { should have_many :stories }
  it { should have_many :recent_stories }
  it { should have_and_belong_to_many :users }
  it { should validate_presence_of :name }
  it { should validate_presence_of :owner_id }
end
