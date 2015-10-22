module NotifyConcern
  extend ActiveSupport::Concern

  private

  def notify(subject, actions_performed)
    Array(actions_performed).each do |action|
      NotificationService.new(subject, action, current_user).notify
    end
  end
end