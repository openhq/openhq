class NotificationsController < ApplicationController
  def index
    page = (params[:page] || 1).to_i
    @notifications = current_user.notifications.page(page).per(20)
  end

  def unseen
    render json: current_user.notifications.unseen
  end

  def mark_all_seen
    current_user.notifications.unseen.each(&:mark_as_seen)
    render nothing: true
  end
end