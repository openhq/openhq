module Api
  module V1
    class NotificationsController < BaseController
      resource_description do
        formats ["json"]
      end

      api! "Fetches all notifications"
      param :limit, Integer, desc: "The number of results you want returned (default: 20)", required: false
      param :page, Integer, desc: "The page you want returned (default: 1)", required: false
      def index
        limit = (params[:limit] || 20).to_i
        page = (params[:page] || 1).to_i

        notifications = current_user.notifications.includes(:team, :project, :story, :actioner).page(page).per(limit)

        has_more = (page * limit) < notifications.total_count
        next_url = api_v1_notifications_path(page: page + 1, limit: limit) if has_more

        meta = {
          total: notifications.total_count,
          has_more: has_more,
          next_url: next_url
        }

        render json: notifications, meta: meta
      end

      api! "Fetches all unseen notifications"
      param :include_seen, [true, false], desc: "Includes seen notifications up to the min_limit, if there are not enough unseen notifications (default: 0)", required: false
      param :min_limit, Integer, desc: "The least number of results you want returned, will always return all unseen (default: 10)", required: false
      def unseen
        min_limit = (params[:min_limit] || 10).to_i

        notifications = current_user.notifications.unseen

        if params[:include_seen] && notifications.count < min_limit
          seen = current_user.notifications.seen.limit(min_limit - notifications.count)
          notifications += seen
        end

        render json: notifications
      end

      api! "Fetch a single notification"
      def show
        notification = current_user.notifications.find(params[:id])
        render json: notification
      end

      api! "Marks all notifications as seen"
      def mark_all_seen
        current_user.notifications.unseen.each(&:seen!)
        head :no_content
      end

      api! "Marks given ids as seen"
      param :ids, Array, desc: "Array of notification ids to be marked as seen", required: true
      def mark_as_seen
        current_user.notifications.unseen.where(id: params[:ids]).each(&:seen!)
        head :no_content
      end
    end
  end
end
