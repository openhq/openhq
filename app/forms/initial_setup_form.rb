class InitialSetupForm
  include ActiveModel::Model

  attr_reader :owner
  attr_accessor :project_name, :team_members

  validates :project_name, :team_members, presence: true

  def initialize(owner)
    @owner = owner
  end

  def submit(params)
    self.project_name = params[:project_name]
    self.team_members = params[:team_members]

    if valid?
      project = owner.created_projects.build(name: project_name)

      if project.save
        project.users << owner

        String(team_members).split(",").each do |email|
          User.invite!(email: email.strip, project_ids: [project.id])
        end

        true
      else
        errors.add(:base, project.errors.full_messages.first)
        false
      end
    end
  end
end
