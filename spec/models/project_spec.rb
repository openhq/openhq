require 'rails_helper'

RSpec.describe Project do
  let(:project) { build(:project) }

  it "must be valid" do
    expect(project).to be_valid
  end
end
