class Task < ActiveRecord::Base
  belongs_to :story
  belongs_to :owner, class_name: "User"
  belongs_to :assignment, class_name: "User", foreign_key: "assigned_to"

  validates_presence_of :label, :story_id

  scope :complete, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }

  def assignment_name
    if assignment.present?
      assignment.username
    else
      "unassigned"
    end
  end
end
