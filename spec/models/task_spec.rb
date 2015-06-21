require 'rails_helper'

RSpec.describe Task do
  let(:task) { build(:task) }

  it "must be valid" do
    expect(task).to be_valid
  end
end
