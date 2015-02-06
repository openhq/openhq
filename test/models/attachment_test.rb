require 'test_helper'

describe Attachment do
  let(:attachment) { build(:attachment) }

  it "must be valid" do
    attachment.must_be :valid?
  end
end