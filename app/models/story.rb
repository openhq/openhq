class Story < ActiveRecord::Base
  belongs_to :project
  has_many :tasks
  has_many :attachments, as: :attachable
  has_many :comments, as: :commentable

end