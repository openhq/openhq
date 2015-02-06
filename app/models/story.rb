class Story < ActiveRecord::Base
  belongs_to :project
  belongs_to :owner, class_name: "User"
  has_many :tasks
  has_many :attachments, as: :attachable
  has_many :comments, as: :commentable

  validates_presence_of :project_id, :name, :owner_id
end