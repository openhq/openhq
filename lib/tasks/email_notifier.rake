namespace :email_notifier do
  desc "Sends updates from the notifications table"
  task send_updates: :environment do
    EmailNotificationsJob.perform_later
  end
end