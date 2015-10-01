class NotificationsController < ApplicationController
  def index
  end

  def unseen
    return unless current_user.present?

    render json: current_user.notifications.unseen.reverse
  end
end