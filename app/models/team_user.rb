class TeamUser < ActiveRecord::Base
  ROLES = %w(user admin owner)

  belongs_to :team
  belongs_to :user

  validates :user, :team, presence: true
  validates :role, presence: true, inclusion: {in: ROLES}

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def assignable_roles
    ROLES[0..ROLES.index(role)]
  end

  def invited_to_sign_up?
    status == "invited"
  end

  def accept_invite!
    update!(status: "active", invite_accepted_at: Time.zone.now)
  end

  def display_role
    if invited_to_sign_up?
      "invited"
    else
      role
    end
  end
end
