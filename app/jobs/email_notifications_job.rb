class EmailNotificationsJob < ActiveJob::Base
  queue_as :default

  def perform
    User.all.each do |user|
      next unless user.due_email_notification?

      notifications = user.notifications.undelivered

      if notifications.any?
        UserMailer.notification_update(user).deliver_later
      end

      user.update(last_notified_at: Time.zone.now)
    end
  end
end
