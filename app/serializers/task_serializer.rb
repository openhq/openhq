class TaskSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :label, :assignment_name, :url, :owner_id, :completed, :due_at, :due_at_pretty
  has_one :assignment
  has_one :project

  def url
    api_v1_task_path(id)
  end

  def due_at_pretty
    return unless due_at.present?

    due_at.to_date.strftime('%e %b, %Y')
  end
end
