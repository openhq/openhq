class PublicController < ApplicationController
  skip_before_action :ensure_team!
  skip_before_action :require_login

  def index
  end
end
