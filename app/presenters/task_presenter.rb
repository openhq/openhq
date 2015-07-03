class TaskPresenter < BasePresenter
  presents :task

  delegate :story, to: :task
  delegate :project, to: :story

  def notifiable_users(action_performed)
    case action_performed
    when "assigned"
      [task.assignment]
    when "created", "completed"
      story.collaborators.where("users.id != :id", id: task.owner_id)
    end
  end

end