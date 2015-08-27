require 'set'

class Story < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  acts_as_paranoid
  after_destroy :update_pg_search
  after_restore :update_pg_search

  include PgSearch
  multisearchable against: [:name, :description], if: :live?

  belongs_to :project, touch: true
  belongs_to :owner, class_name: "User"
  has_many :tasks, -> { order(completed: :asc, order: :asc, created_at: :asc) }
  has_many :attachments
  has_many :comments, as: :commentable
  has_many :users, -> { uniq }, through: :comments, source: :owner

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

  def update_pg_search
    update_pg_search_document

    [tasks, attachments, comments].each do |dependants|
      dependants.each do |dependant|
        dependant.update_pg_search_document
      end
    end
  end
end