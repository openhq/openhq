class NotificationService
  attr_reader :notifiable, :presenter, :action_performed

  def initialize(notifiable, action_performed)
    @notifiable = notifiable
    @presenter = present(notifiable)
    @action_performed = action_performed
  end

  def notify
    presenter.notifiable_users.each do |user|
      user.notifications.create(
        project: presenter.project,
        story: presenter.story,
        notifiable: notifiable,
        action_performed: action_performed
      )
    end
  end

  private

  def present notifiable
    "#{notifiable.class}Presenter".constantize.new(notifiable, self)
  end

end