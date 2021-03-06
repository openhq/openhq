require 'set'

class Story < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_tenant(:team)
  acts_as_paranoid

  include Searchable
  searchable against: [:name, :description], if: :live?, with_fields: [:project_id, :story_id, :team_id]

  after_destroy :reindex_children
  after_restore :reindex_children

  belongs_to :project, touch: true
  belongs_to :owner, class_name: "User"
  has_many :tasks, -> { order(completed: :asc, order: :asc, created_at: :asc) }
  has_many :attachments, -> { order(created_at: :desc) }
  has_many :comments, -> { order(created_at: :desc) }, as: :commentable
  has_many :comments_unordered, as: :commentable, class_name: "Comment"
  has_many :users, -> { distinct }, through: :comments_unordered, source: :owner

  validates_presence_of :project_id, :name, :owner_id

  scope :recent, -> { order(updated_at: :desc) }

  def collaborators
    collaborator_ids = Set.new(users.pluck(:id))

    collaborator_ids << owner_id

    User.where("id IN (?)", collaborator_ids)
  end

  def live?
    !deleted? && project.present? && project.live?
  end

  def story_id
    id
  end

  def reindex_children
    [tasks, attachments, comments].flatten.each(&:index_search_document)
  end
end
