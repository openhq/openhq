class TeamController < ApplicationController
  def index
    @team_members = User.all.sort_by {|u| User::ROLES.index(u.role) }.reverse
  end

  def edit
  end
end
