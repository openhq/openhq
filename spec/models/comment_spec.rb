require 'rails_helper'

RSpec.describe Comment do
  let(:comment) { build(:comment) }

  it "must be valid" do
    expect(comment).to be_valid
  end
end
