class PublicController < ApplicationController
  layout "auth"
  skip_before_action :ensure_team!

  def index
  end
end
