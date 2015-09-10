module SignInGuards
  class IsTeamMemberGuard < ::Clearance::SignInGuard
    def call
      # current_team will be nil when signing in from the root domain
      # on first signup
      if current_team.nil? || member_of_team?
        next_guard
      else
        failure("You’re not a member of #{current_team.name}")
      end
    end

    def member_of_team?
      signed_in? && current_team.users.exists?(current_user.id)
    end

    private

    def current_team
      ActsAsTenant.current_tenant
    end
  end
end
