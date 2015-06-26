namespace :email_notifier do

  desc "Sends updates from the notifications table"
  task send_updates: :environment do
    User.all.each do |user|
      if user.expecting_email_update?
        notifications = user.notifications.undelivered

        if notifications.any?
          EmailNotificationUpdateJob.perform_now(user, notifications)
        end

        user.update(last_notified_at: Time.now)
      end
    end
  end

end