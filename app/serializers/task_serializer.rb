class TaskSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :label, :assigned_to, :assignment_name, :url, :owner_id, :completed, :due_at, :due_at_pretty
  has_one :assignment
  has_one :project
  has_many :comments, each_serializer: CommentSerializer

  def url
    api_v1_task_path(object.id)
  end

  def due_at_pretty
    return unless object.due_at.present?

    object.due_at.to_date.strftime('%e %b, %Y')
  end
end
