class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :owner, class_name: "User"

  validates_presence_of :content, :owner_id
end