class Team::Invite
  include ActiveModel::Model
  attr_accessor :email, :project_ids, :user
  attr_reader :team, :inviter
  validates :email, email: true, presence: true
  validate :user_can_access_projects

  def initialize(params, team, inviter)
    @email = params[:email]
    @project_ids = Array(params[:project_ids])
    @team = team
    @inviter = inviter
  end

  def save
    return false unless valid?

    @user = team.invite({email: email, project_ids: project_ids}, inviter)

    if @user.persisted?
      true
    else
      # Add user errors directly to invite errors
      @user.errors.full_messages.each { |err| errors.add(:base, err) }
      false
    end
  end

  private

  def user_can_access_projects
    project_ids.select! do |pid|
      inviter.project_ids.include?(Integer(pid)) unless pid.empty?
    end
  end
end