module SignInGuards
  class NotDeletedGuard < ::Clearance::SignInGuard
    def call
      if signed_in? && current_user.deleted_at.nil?
        next_guard
      else
        failure("Your account has been archived.")
      end
    end
  end
end
