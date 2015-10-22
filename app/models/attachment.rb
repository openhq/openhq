require_dependency 's3_url_signer'

class Attachment < ActiveRecord::Base
  THUMBNAIL_SIZES = { thumb: [600, 400], tile: [118, 154] }

  include Searchable
  searchable against: [:name, :file_name, :process_data], if: :live?, with_fields: [:project_id, :story_id, :team_id]

  acts_as_tenant(:team)

  belongs_to :attachable, polymorphic: true
  belongs_to :story
  has_one :project, through: :story
  belongs_to :owner, class_name: "User"

  validates :file_name, :file_path, :owner, presence: true

  after_create :process_upload

  delegate :project_id, to: :story

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

  def thumbnail_sizes
    THUMBNAIL_SIZES
  end

  def set_process_data(key, val)
    data = process_data
    data[key] = val

    update(process_data: data)
  end

  def live?
    story.present? && story.live?
  end

  private

  def process_upload
    ProcessAttachmentJob.perform_later(self)
  end
end
