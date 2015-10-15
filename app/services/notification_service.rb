class NotificationService
  include PresenterHelper

  attr_reader :notifiable, :presenter, :action_performed, :actioner

  def initialize(notifiable, action_performed, actioner)
    @notifiable = notifiable
    @presenter = present(notifiable)
    @action_performed = action_performed
    @actioner = actioner
  end

  def notify
    users = presenter.notifiable_users(action_performed)

    return if users.nil? || users.empty?

    users.each do |user|
      next if user.notification_frequency == "never"

      n = user.notifications.create(
        project: presenter.project,
        story: presenter.story,
        notifiable: notifiable,
        action_performed: action_performed,
        actioner: actioner
      )

      MessageBus.publish "/user/#{user.id}/notifications", id: n.id
    end
  end

end