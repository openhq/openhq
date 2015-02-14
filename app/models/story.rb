class Story < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :project
  belongs_to :owner, class_name: "User"
  has_many :tasks
  has_many :attachments, -> { includes(:attachment) }, as: :attachable, class_name: "Attachable"
  has_many :comments, -> { includes(:comment) }, as: :commentable, class_name: "Commentable"

  validates_presence_of :project_id, :name, :owner_id
end
