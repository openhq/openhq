require 'rails_helper'

RSpec.describe User do
  let(:user) { build(:user) }

  it "must be valid" do
    expect(user).to be_valid
  end
end
