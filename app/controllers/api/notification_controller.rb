module Api
  class NotificationController < ApplicationController
    def show
      n = current_user.notifications.find(params[:id])

      if n.present?
        render json: n, status: 200
      else
        render nothing: true, status: 400
      end
    end
  end
end