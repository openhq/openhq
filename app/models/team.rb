class Team < ActiveRecord::Base
  has_many :team_users, -> { where(status: "active") }
  has_many :user_invites, -> { where(status: "invited") }, class_name: "TeamUser"
  has_many :users, through: :team_users
  has_many :invited_users, through: :user_invites, source: :user
  has_many :projects

  validates :name, :subdomain, presence: true
  validates_uniqueness_of :subdomain

  before_create :generate_setup_code

  def self.only_team
    team = Team.first
    team = create!(name: "Open HQ", subdomain: "openhq") unless team
    team
  end

  def invite(user_params, inviter)
    # TODO - Add the user to the projects if they already exist or have a callback
    #        to add them if they accept the invitation.

    user = User.find_by(email: user_params[:email]) || User.new(user_params.merge(password: SecureRandom.hex(16)))

    transaction do
      user.save!(validate: false) unless user.persisted?

      # skip the transaction if the user is already on the team
      fail ActiveRecord::Rollback if team_users.pluck(:user_id).include?(user.id)

      team_invite = user_invites.find_by(user_id: user.id)

      # only create an invite if one doesn't already exist
      if team_invite.nil?
        team_invite = team_users.create!(
          user: user,
          role: "user",
          status: "invited",
          invitation_code: SecureRandom.urlsafe_base64,
          invited_at: Time.zone.now,
          invited_by: inviter.id
        )
      end

      # Add projects to the user
      user_params[:project_ids].each do |pid|
        user.projects << Project.find(pid) unless user.project_ids.include?(pid.to_i)
      end

      UserMailer.team_invite(team_invite, inviter).deliver_later
    end

    user
  end

  private

  def generate_setup_code
    self.setup_code = SecureRandom.urlsafe_base64
  end
end
