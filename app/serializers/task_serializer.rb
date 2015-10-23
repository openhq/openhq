class TaskSerializer < ActiveModel::Serializer
  attributes :id, :label, :assignment_name, :project, :story, :url, :project_users, :completed, :due_at, :due_at_pretty
  has_one :assignment

  def url
    api_v1_task_path(id)
  end

  def project_users
    project.users_select_array
  end

  def due_at_pretty
    return unless due_at.present?

    due_at.to_date.strftime('%e %b, %Y')
  end
end
