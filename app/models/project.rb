class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  acts_as_paranoid
  after_destroy :update_pg_search
  after_restore :update_pg_search

  include PgSearch
  multisearchable against: [:name], if: :live?

  belongs_to :owner, class_name: "User"
  has_many :stories
  has_and_belongs_to_many :users

  validates_presence_of :name, :owner_id

  def self.all_cache_key
    max_updated_at = maximum(:updated_at).try(:utc).try(:to_s, :number)
    "project/all/#{max_updated_at}"
  end

  def users_select_array
    @users_select_array ||= [['unassigned', 0]].concat(users.active.pluck(:username, :id))
  end

  def live?
    !deleted?
  end

  def update_pg_search
    update_pg_search_document

    stories.each do |story|
      story.update_pg_search
    end
  end

end
