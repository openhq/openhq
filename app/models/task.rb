class Task < ActiveRecord::Base
  include Searchable
  searchable against: [:label], if: :live?, with_fields: [:project_id, :story_id, :team_id]

  acts_as_tenant(:team)

  belongs_to :story, touch: true
  has_one :project, through: :story
  belongs_to :owner, class_name: "User"
  belongs_to :assignment, class_name: "User", foreign_key: "assigned_to"
  belongs_to :completer, class_name: "User", foreign_key: "completed_by"

  validates_presence_of :label, :story_id

  scope :complete, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }

  delegate :project_id, to: :story

  def self.overdue
    where('due_at IS NOT NULL AND due_at < ?', Time.zone.now - 1.day)
  end

  def self.today
    where('due_at IS NOT NULL AND due_at > ? AND due_at < ?', Time.zone.now - 1.day, Time.zone.now)
  end

  def self.this_week
    where('due_at IS NOT NULL AND due_at > ? AND due_at < ?', Time.zone.now, Time.zone.now + 6.days)
  end

  def self.all_other
    where('due_at IS NULL OR due_at > ?', Time.zone.now + 6.days)
  end

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
