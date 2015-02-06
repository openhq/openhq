require 'test_helper'

describe Task do
  let(:task) { build(:task) }

  it "must be valid" do
    task.must_be :valid?
  end
end