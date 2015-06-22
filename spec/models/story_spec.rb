require 'rails_helper'

RSpec.describe Story do
  let(:story) { build(:story) }

  it "must be valid" do
    expect(story).to be_valid
  end
end
