class Comment < ActiveRecord::Base
  attr_reader :attachment_ids

  include PgSearch
  multisearchable against: [:content], if: :live?

  acts_as_tenant(:team)

  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :owner, class_name: "User"
  has_many :attachments, as: :attachable

  validates_presence_of :content, :owner_id

  def live?
    commentable.present? && commentable.live?
  end
end
