require "sign_in_guards/is_team_member_guard"
require "sign_in_guards/not_deleted_guard"

Clearance.configure do |config|
  config.routes = false # Routes managed manually
  config.allow_sign_up = false
  config.mailer_sender = ENV["DEFAULT_FROM_EMAIL"]
  config.sign_in_guards = [SignInGuards::IsTeamMemberGuard, SignInGuards::NotDeletedGuard]
end
