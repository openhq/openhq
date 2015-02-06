require 'test_helper'

describe Project do
  let(:project) { build(:project) }

  it "must be valid" do
    project.must_be :valid?
  end
end