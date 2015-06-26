namespace :email_notifier do

  desc "Sends updates from the notifications table"
  task send_updates: :environment do
    User.all.each do |user|
      if user.expecting_email_update?
        notifications = user.notifications.undelivered

        if notifications.any?
          UserMailer.notification_update(user, notifications).deliver_now

          notifications.each do |n|
            n.delivered!
          end
        end
      end
    end
  end

end