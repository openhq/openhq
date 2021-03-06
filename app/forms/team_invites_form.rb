class TeamInvitesForm
  include ActiveModel::Model

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  attr_reader :team, :owner, :project_ids
  attr_accessor :members

  validates :members, presence: true
  validate :valid_members_emails

  def initialize(team, owner, project_ids: [])
    @team = team
    @owner = owner
    @project_ids = project_ids
  end

  def submit(params)
    self.members = params[:members]

    if valid?
      # Do the inviting
      members.each_line do |email|
        team.invite({email: email.strip, project_ids: project_ids}, owner) unless email.strip.empty?
      end

      true
    else
      false
    end
  end

  def valid_members_emails
    members.each_line do |email|
      next if email.strip.empty?

      unless email.strip =~ EMAIL_REGEX
        errors.add(:members, "#{email} is not a valid email address")
      end
    end
  end
end
