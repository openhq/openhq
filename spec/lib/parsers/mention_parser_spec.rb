require 'rails_helper'
require 'parsers/mention_parser'

RSpec.describe MentionParser do
  let!(:frank) { create(:user, username: "frank") }
  let!(:mac) { create(:user, username: "mac") }
  let!(:charlie) { create(:user, username: "charlie") }

  it "returns nil if string not passed through" do
    mentioned = MentionParser.users("")

    expect(mentioned).to equal(nil)
  end

  it "only finds the at mentioned users" do
    string = "@mac and @charlie, you've been at mentioned, but frank hasn't."
    mentioned = MentionParser.users(string)

    expect(mentioned.count).to equal(2)
    expect(mentioned).to include(mac)
    expect(mentioned).to include(charlie)
    expect(mentioned).not_to include(frank)
  end

  it "returns nil if no one has been at mentioned" do
    string = "mac, charlie and frank have not been at mentioned"
    mentioned = MentionParser.users(string)

    expect(mentioned).to equal(nil)
  end
end