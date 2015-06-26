class EmailNotificationUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    notifications = user.notifications.undelivered
    if notifications.any?
      UserMailer.notification_update(user, notifications).deliver_later

      notifications.each do |n|
        n.delivered!
      end
    end
  end
end