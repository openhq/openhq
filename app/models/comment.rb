class Comment < ActiveRecord::Base
  attr_reader :attachment_ids

  include Searchable
  searchable against: [:content], if: :live?, with_fields: [:project_id, :story_id, :team_id]

  acts_as_tenant(:team)

  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :owner, class_name: "User"
  has_many :attachments, as: :attachable

  validates_presence_of :content, :owner_id

  def live?
    commentable.present? && commentable.live?
  end

  def project_id
    commentable.project_id if commentable.present? && commentable.live?
  end

  # This will need to change if we ever add comments to anything other than stories
  def story_id
    commentable_id
  end
end
