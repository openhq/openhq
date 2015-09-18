module SignInGuards
  class IsTeamMemberGuard < ::Clearance::SignInGuard
    def call
      # current_team will be nil when signing in from the root domain
      # on first signup
      if signed_in? && !member_of_team?
        failure("You’re not a member of #{current_team.name}")
      else
        next_guard
      end
    end

    def member_of_team?
      current_team.nil? || current_team.users.exists?(current_user.id)
    end

    private

    def current_team
      ActsAsTenant.current_tenant
    end
  end
end
