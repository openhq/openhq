require 'rails_helper'

describe Metadata do
  let(:metadata) { build(:metadata) }

  it "must be valid" do
    expect(metadata).to be_valid
  end
end
