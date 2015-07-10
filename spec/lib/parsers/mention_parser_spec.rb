require 'rails_helper'
require 'parsers/mention_parser'

RSpec.describe MentionParser do
  let!(:frank) { create(:user, username: "frank") }
  let!(:mac) { create(:user, username: "mac") }
  let!(:charlie) { create(:user, username: "charlie") }

  it "only finds the at mentioned users" do
    string = "@mac and @charlie, you've been at mentioned, but frank hasn't."
    mentioned = MentionParser.users(string)

    expect(mentioned).to include(mac)
    expect(mentioned).to include(charlie)
    expect(mentioned).not_to include(frank)
  end
end