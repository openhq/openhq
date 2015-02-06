class Task < ActiveRecord::Base
  belongs_to :story

  validates_presence_of :label, :story_id
end