require 'rails_helper'

RSpec.describe User do
  let(:user) { build(:user) }

  it { is_expected.to have_many(:created_projects) }
  it { is_expected.to have_many(:stories) }
  it { is_expected.to have_many(:notifications) }
  it { is_expected.to have_and_belong_to_many(:projects) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:notification_frequency) }
  it { is_expected.to validate_presence_of(:username) }

  it { is_expected.to allow_value("freddy1997").for(:username) }
  it { is_expected.to allow_value("freddy_1997").for(:username) }
  it { is_expected.to allow_value("freddy-1997").for(:username) }
  it { is_expected.not_to allow_value("@freddyZ").for(:username) }

  it "must be valid" do
    expect(user).to be_valid
  end

  describe ".not_deleted" do
    it "ignores deleted users" do
      create(:user, deleted_at: Time.now)
      expect(User.not_deleted.any?).to be(false)
    end
  end

  describe ".active" do
    xit "ignores invited users" do
      User.invite!(email: "josh.weinstein@example.org")
      expect(User.active.any?).to be(false)
    end
  end

  describe ".notification_frequencies" do
    it "returns an array" do
      expect(User.notification_frequencies).to include("never")
    end
  end

  describe "#due_email_notification?" do
    let(:frank) { create(:user, username: "franko", notification_frequency: "daily", last_notified_at: Time.now - 23.hours) }
    let(:sweet_dee) { create(:user, username: "sweet_dee_123", notification_frequency: "hourly", last_notified_at: Time.now - 56.minutes) }
    let(:charlie) { create(:user, username: "charlie_work", notification_frequency: "asap", last_notified_at: Time.now - 10.minutes) }
    let(:mack) { create(:user, username: "cultivating_mass", notification_frequency: "never") }

    it "fails if users are emailed too frequently" do
      [frank, sweet_dee, mack].each do |user|
        expect(user.due_email_notification?).to be(false)
      end

      expect(charlie.due_email_notification?).to be(true)
    end

    it "passes when users are emailed in due time" do
      frank.update(last_notified_at: Time.now - 25.hours)
      sweet_dee.update(last_notified_at: Time.now - 2.hours)

      [frank, sweet_dee, charlie].each do |user|
        expect(user.due_email_notification?).to be(true)
      end

      expect(mack.due_email_notification?).to be(false)
    end
  end

  describe "#full_name" do
    it "strips whitespace" do
      expect(build(:user, first_name: "Mack", last_name: nil).full_name).to eq("Mack")
      expect(build(:user, first_name: " Charlie", last_name: "Day ").full_name).to eq("Charlie Day")
    end
  end

  describe "#display_name" do
    context "when user has a name" do
      it do
        user = User.new(
          email: "jeff.bridges@example.org",
          username: "jeff_bridges",
          first_name: "Jeff",
          last_name: "Bridges"
        )
        expect(user.display_name).to eq("Jeff Bridges")
      end
    end

    context "when user has a username" do
      it do
        user = User.new(
          email: "jeff.bridges@example.org",
          username: "jeff_bridges"
        )
        expect(user.display_name).to eq("jeff_bridges")
      end
    end

    context "when user only has an email" do
      it do
        user = User.new(email: "jeff.bridges@example.org")
        expect(user.display_name).to eq("jeff.bridges@example.org")
      end
    end
  end
end
