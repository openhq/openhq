class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :story
  belongs_to :notifiable, polymorphic: true

  scope :undelivered, -> { where(delivered: false) }

  def delivered!
    update(delivered: true)
  end

  def partial
    "/user_mailer/notification_partials/#{notifiable.class.to_s.underscore}_#{action_performed}"
  end
end