require_dependency 's3_url_signer'

class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  belongs_to :story
  belongs_to :owner, class_name: "User"

  validates_presence_of :owner_id

  def self.all_for_user(user)
    users_story_ids = Story.where("stories.project_id IN (?)", user.project_ids).pluck(:id)
    where("attachments.story_id IN (?)", users_story_ids).order(created_at: :desc)
  end

  def attach_to(object)
    self.attachable = object
    save!
  end

  def extension
    ext = File.extname(file_name)
    ext[0] = ""
    ext.downcase
  end

  def image?
    content_type.match(%r{^image\/})
  end

  def url
    S3UrlSigner.sign(file_path)
  end
end
