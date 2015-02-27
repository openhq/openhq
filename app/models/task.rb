class Task < ActiveRecord::Base
  belongs_to :story
  belongs_to :owner, class_name: "User"
  belongs_to :assignment, class_name: "User", foreign_key: "assigned_to"

  validates_presence_of :label, :story_id

  scope :incomplete, -> { where(completed: false) }
end
