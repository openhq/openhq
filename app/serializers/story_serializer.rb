class StorySerializer < ActiveModel::Serializer
  include TagHelper

  attributes :id, :project_id, :team_id, :owner_id, :name, :slug, :description, :markdown, :created_at, :updated_at, :deleted_at
  belongs_to :owner
  belongs_to :project
  has_many :comments
  has_many :tasks

  def markdown
    markdownify(object.description)
  end
end
