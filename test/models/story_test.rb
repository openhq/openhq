require 'test_helper'

describe Story do
  let(:story) { build(:story) }

  it "must be valid" do
    story.must_be :valid?
  end
end