class Task < ActiveRecord::Base
  include Searchable
  searchable against: [:label], if: :live?, with_fields: [:project_id, :story_id, :team_id]

  acts_as_tenant(:team)

  belongs_to :story, touch: true
  belongs_to :owner, class_name: "User"
  belongs_to :assignment, class_name: "User", foreign_key: "assigned_to"
  belongs_to :completer, class_name: "User", foreign_key: "completed_by"

  validates_presence_of :label, :story_id

  scope :complete, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }

  delegate :project_id, to: :story

  def assignment_name
    if assignment.present?
      assignment.username
    else
      "unassigned"
    end
  end

  def update_completion_status(status, user)
    update(
      completed: status,
      completed_by: user.id,
      completed_on: Time.zone.now
    )
  end

  def live?
    story.present? && story.live?
  end
end
