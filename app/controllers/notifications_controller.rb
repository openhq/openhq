class NotificationsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        page = (params[:page] || 1).to_i
        @notifications = current_user.notifications.page(page).per(20)
      end
      format.json do
        notifications = ActiveModel::ArraySerializer.new(current_user.notifications.unseen).as_json
        if notifications.count < 10
          seen = current_user.notifications.seen.limit(10 - notifications.count)
          notifications += ActiveModel::ArraySerializer.new(seen).as_json
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