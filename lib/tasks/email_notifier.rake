namespace :email_notifier do

  desc "Sends updates from the notifications table"
  task send_updates: :environment do
    User.all.each do |user|
      if user.expecting_email_update?
        EmailNotificationUpdateJob.perform_later(user)
      end
    end
  end

end