class NotificationsController < ApplicationController
  def index
  end

  def unseen
    return unless current_user.present?

    render json: current_user.notifications.unseen.reverse
  end

  def mark_all_seen
    return unless current_user.present?

    current_user.notifications.unseen.each(&:mark_as_seen)
    render nothing: true
  end
end