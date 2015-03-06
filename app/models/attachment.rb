class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  belongs_to :story
  belongs_to :owner, class_name: "User"

  has_attached_file :attachment
  validates_attachment_presence :attachment
  # TODO: what all file types do we allow to upload?
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/

  validates_presence_of :owner_id

  def attach_to(object)
    self.attachable = object
    self.save!
  end
end
