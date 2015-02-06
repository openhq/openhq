require 'test_helper'

describe Comment do
  let(:comment) { build(:comment) }

  it "must be valid" do
    comment.must_be :valid?
  end
end