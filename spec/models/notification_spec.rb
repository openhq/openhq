require "rails_helper"

RSpec.describe Notification do
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should belong_to(:story) }
  it { should belong_to(:notifiable) }

  describe ".undelivered" do
    it "doesn’t include delivered notifications" do
      create(:notification)
      create(:notification, delivered: true)

      expect(Notification.undelivered.count).to eq(1)
    end
  end

  describe "#delivered!" do
    it "marks the notification as delivered" do
      notification = create(:notification)
      notification.delivered!
      expect(notification.delivered?).to be(true)
    end
  end
end
