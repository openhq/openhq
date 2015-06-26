class TaskPresenter < BasePresenter
  presents :task

  def project
    story.project
  end

  def story
    task.story
  end

  def notifiable_users(action_performed)
    case action_performed
    when "invited"
      [task.assignment]
    else
      collaborator_ids = story.collaborators.map { |u| u[:id] == task.owner.id ? nil : u[:id] }
      User.where('id IN (?)', collaborator_ids)
    end
  end

end