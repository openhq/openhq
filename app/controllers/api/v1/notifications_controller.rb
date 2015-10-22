module Api
  module V1
    class NotificationsController < BaseController
      resource_description do
        formats ["json"]
      end

      api! "Fetches all unseen notifications, and appends seen notifications if unseen is less than the limit"
      param :limit, Integer, desc: "The least number of results you want returned, will always return all unseen (default: 10)", required: false
      def index
        limit = (params[:limit] || 10).to_i
        notifications = current_user.notifications.unseen

        if notifications.count < limit
          seen = current_user.notifications.seen.limit(limit - notifications.count)
          notifications += seen
        end
        render json: notifications, each_serializer: NotificationApiSerializer
      end

      api! "Fetch a single notification"
      def show
        notification = current_user.notifications.find(params[:id])
        notification.seen!

        render json: notification, serializer: NotificationApiSerializer
      end

      api! "Marks all notifications as seen"
      def mark_all_seen
        current_user.notifications.unseen.each(&:seen!)
        render nothing: true, status: 204
      end
    end
  end
end
