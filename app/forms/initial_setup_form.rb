class InitialSetupForm
  include ActiveModel::Model

  attr_reader :owner, :current_team
  attr_accessor :project_name, :team_members

  validates :project_name, :team_members, presence: true

  def initialize(owner, current_team)
    @owner = owner
    @current_team = current_team
  end

  def submit(params)
    self.project_name = params[:project_name]
    self.team_members = params[:team_members]

    if valid?
      project = owner.created_projects.build(name: project_name)

      if project.save
        project.users << owner

        String(team_members).split(",").each do |email|
          current_team.invite({email: email.strip, project_ids: [project.id]}, owner)
        end

        true
      else
        errors.add(:base, project.errors.full_messages.first)
        false
      end
    end
  end
end
