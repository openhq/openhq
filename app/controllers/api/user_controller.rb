module Api
  class UserController < ApplicationController
    skip_before_action :require_login

    def index
      if signed_in?
        render json: current_user, status: 200
      else
        render json: "not logged in", status: 400
      end
    end

  end
end