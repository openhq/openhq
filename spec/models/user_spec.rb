require 'rails_helper'

RSpec.describe User do
  let(:user) { build(:user) }

  it { should have_many(:created_projects) }
  it { should have_many(:stories) }
  it { should have_many(:notifications) }
  it { should have_and_belong_to_many(:projects) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:role) }
  it { should validate_presence_of(:notification_frequency) }
  it { should validate_presence_of(:username) }

  it { should allow_value("freddy1997").for(:username) }
  it { should allow_value("freddy_1997").for(:username) }
  it { should allow_value("freddy-1997").for(:username) }
  it { should_not allow_value("@freddyZ").for(:username) }

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
    it "ignores invited users" do
      User.invite!(email: "josh.weinstein@example.org")
      expect(User.active.any?).to be(false)
    end
  end

  describe ".notification_frequencies" do
    it "returns an array" do
      expect(User.notification_frequencies).to include("never")
    end
  end

  describe "#active_for_authentication?" do
    it "disables archived users from logging in" do
      deborah = create(:user, username: "deborah")
      archived_bob = create(:user, username: "archived_bob", deleted_at: Time.zone.now)
      expect(archived_bob.active_for_authentication?).to be(false)
      expect(deborah.active_for_authentication?).to be(true)
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
