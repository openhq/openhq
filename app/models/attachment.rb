class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  belongs_to :story
  belongs_to :owner, class_name: "User"

  validates_presence_of :owner_id

  def attach_to(object)
    self.attachable = object
    save!
  end

  def url
    file_path
  end
end
