class EmailNotificationUpdateJob < ActiveJob::Base
  queue_as :default

  def perform
    User.all.each do |user|
      if user.expecting_email_update?
        notifications = user.notifications.undelivered

        if notifications.any?
          UserMailer.notification_update(user, notifications).deliver_later
          user.notifications.undelivered.each do |n|
            n.delivered!
          end
        end

        user.update(last_notified_at: Time.now)
      end
    end

  end
end