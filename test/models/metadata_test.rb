require 'test_helper'

describe Metadata do
  let(:metadata) { build(:metadata) }

  it "must be valid" do
    metadata.must_be :valid?
  end
end