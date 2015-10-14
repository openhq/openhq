class MeController < ApplicationController
  def index
    tasks = current_user.tasks.incomplete.includes(:project, :story).order(due_at: :asc)

    @overdue_tasks = tasks.where('due_at IS NOT NULL AND due_at < ?', Time.zone.now - 1.day)
    @todays_tasks = tasks.where('due_at IS NOT NULL AND due_at > ? AND due_at < ?', Time.zone.now - 1.day, Time.zone.now)
    @weeks_tasks = tasks.where('due_at IS NOT NULL AND due_at > ? AND due_at < ?', Time.zone.now, Time.zone.now + 6.days)
    @other_tasks = tasks.where('due_at IS NULL OR due_at > ?', Time.zone.now + 6.days)
  end
end