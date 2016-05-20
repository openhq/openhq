module Setup
  class SingleSiteController < ApplicationController
    layout "setup"
    skip_before_action :require_login
    skip_before_action :run_first_time_setup
    before_action :ensure_single_site_install, only: [:index, :create]
    before_action :ensure_no_users, only: [:index, :create]
    before_action :check_aws_credentials!, only: [:index, :create]

    def index
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        current_team.team_users.create!(user: @user, role: "owner")
        sign_in @user

        redirect_to setup_first_project_path
      else
        render :first_time_user
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :avatar)
    end

    def ensure_single_site_install
      redirect_to root_url if multisite_install?
    end

    def ensure_no_users
      redirect_to root_url if current_team.users.count > 0
    end

    def check_aws_credentials!
      s3 = AWS::S3.new
      bucket = s3.buckets[ENV.fetch('AWS_S3_BUCKET')]
      s3.buckets.create(ENV.fetch('AWS_S3_BUCKET')) unless bucket.exists?

    rescue StandardError
      render :invalid_aws_credentials
    end
  end
end
