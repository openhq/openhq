class EmailNotificationUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(user, notifications)
    UserMailer.notification_update(user, notifications).deliver_now

    user.notifications.undelivered.each do |n|
      n.delivered!
    end
  end
end