require 'test_helper'

describe User do
  let(:user) { build(:user) }

  it "must be valid" do
    user.must_be :valid?
  end
end