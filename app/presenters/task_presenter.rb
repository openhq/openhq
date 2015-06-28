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
    when "assigned"
      [task.assignment]
    else
      story.collaborators.where("users.id != :id", id: task.owner_id)
    end
  end

end