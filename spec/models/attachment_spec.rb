require 'rails_helper'

RSpec.describe Attachment do
  let(:attachment) { build(:attachment) }

  it "must be valid" do
    expect(attachment).to be_valid
  end
end
