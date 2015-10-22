module CurrentTeamAbilityConcern
  extend ActiveSupport::Concern

  included do
    helper_method :current_team_role
  end

  private

  def current_team_role
    current_user.team_users.find_by(team_id: current_team.id)
  end

  def current_ability
    @current_ability ||= Ability.new(current_team_role)
  end
end