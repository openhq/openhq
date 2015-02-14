class Attachment < ActiveRecord::Base
  belongs_to :attachable
  belongs_to :owner, class_name: "User"

  validates_presence_of :name, :path, :size, :content_type, :owner_id
end
