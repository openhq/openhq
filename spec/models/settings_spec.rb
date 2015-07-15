require "rails_helper"

RSpec.describe Settings do
  let(:settings) { Settings.load }

  it "loads saved settings" do
    settings.update(organisation_name: "Tilde")
    expect(Settings.load.organisation_name).to eq("Tilde")
  end
end
