module Api
  class NotificationController < ApplicationController
    def show
      n = current_user.notifications.find(params[:id])
      render json: n, status: 200
    end
  end
end