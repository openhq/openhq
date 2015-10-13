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

      team_invite = team_users.create!(
        user: user,
        role: "user",
        status: "invited",
        invitation_code: SecureRandom.urlsafe_base64,
        invited_at: Time.zone.now,
        invited_by: inviter.id
      )

      UserMailer.team_invite(team_invite, inviter).deliver_later
    end

    user
  end

  private

  def generate_setup_code
    self.setup_code = SecureRandom.urlsafe_base64
  end
end
