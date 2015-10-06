class TaskSerializer < ActiveModel::Serializer
  attributes :id, :label, :assignment_name, :project, :story, :url, :project_users, :completed

  def url
    project_story_task_path(project, story, id)
  end

  def project_users
    project.users_select_array
  end
end