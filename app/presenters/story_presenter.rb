class StoryPresenter < BasePresenter
  presents :story

  delegate :project, to: :story

  def task_completion
    complete_tasks = story.tasks.complete.count
    total_tasks = story.tasks.count
    return 0 if total_tasks == 0
    ((complete_tasks.to_f / total_tasks.to_f) * 100).round
  end

  def task_completion_width
    return 10 if task_completion < 10
    task_completion
  end

  def notifiable_users(action_performed)
    case action_performed
    when "created"
      project.users.where('user_id != ?', story.owner_id)
    when "mentioned"
      mentioned_users(story.description)
    end
  end

end