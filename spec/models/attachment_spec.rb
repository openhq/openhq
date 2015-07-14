require 'rails_helper'

RSpec.describe Attachment do
  let(:attachment) { build(:attachment) }

  it { should belong_to(:attachable) }
  it { should belong_to(:story) }
  it { should belong_to(:owner) }

  it { should validate_presence_of(:owner_id) }

  it "must be valid" do
    expect(attachment).to be_valid
  end

  describe "#extension" do
    let(:image) { build(:attachment, file_name: "white-russian.JPG") }
    let(:video) { build(:attachment, file_name: "film.mov") }

    it "returns the file extension" do
      expect(image.extension).to eq("jpg")
      expect(video.extension).to eq("mov")
    end
  end
end
