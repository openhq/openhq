class Comment < ActiveRecord::Base
  attr_reader :attachment_ids

  include Searchable
  searchable against: [:content], if: :live?, with_fields: [:project_id, :story_id, :team_id]

  acts_as_tenant(:team)

  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :owner, class_name: "User"
  has_many :attachments, as: :attachable

  delegate :project, to: :commentable

  validates_presence_of :content, :owner_id

  def live?
    commentable.present? && commentable.live?
  end

  def project_id
    commentable.project_id if commentable.present? && commentable.live?
  end

  def story_id
    case commentable_type
    when "Story"
      commentable_id
    when "Task"
      commentable.story_id
    else
      nil
    end
  end

  def story
    Story.find(story_id) unless story_id.nil?
  end
end
