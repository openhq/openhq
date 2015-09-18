module SignInGuards
  class NotDeletedGuard < ::Clearance::SignInGuard
    def call
      if signed_in? && current_user.deleted_at.present?
        failure("Your account has been archived.")
      else
        next_guard
      end
    end
  end
end
