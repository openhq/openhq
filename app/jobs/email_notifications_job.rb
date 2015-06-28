class EmailNotificationsJob < ActiveJob::Base
  queue_as :default

  def perform
    User.all.each do |user|
      if user.expecting_email_update?
        notifications = user.notifications.undelivered

        if notifications.any?
          p "Sending update email to: #{user.username}"
          UserMailer.notification_update(user).deliver_later
          user.notifications.undelivered.each do |n|
            n.delivered!
          end
        else
          p "No notifications for: #{user.username}"
        end

        user.update(last_notified_at: Time.now)
      else
        p "#{user.username} is not expecting an email"
      end
    end
  end
end