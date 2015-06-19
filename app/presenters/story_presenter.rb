class StoryPresenter < BasePresenter
  presents :story

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

end
