class PublicController < ApplicationController
  skip_before_action :require_login

  def index
  end

  def help
  end
end
