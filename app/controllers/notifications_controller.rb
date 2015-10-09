class NotificationsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        page = (params[:page] || 1).to_i
        @notifications = current_user.notifications.page(page).per(20)
      end
      format.json do
        notifications = current_user.notifications.unseen
        if notifications.length < 10
          seen = current_user.notifications.seen.limit(10 - notifications.count)
          seen.each { |n| notifications << n }
        end
        render json: notifications
      end
    end
  end

  def mark_all_seen
    current_user.notifications.unseen.each(&:seen!)
    render nothing: true
  end
end