class StorySerializer < ActiveModel::Serializer
  include TagHelper

  attributes :id, :project_id, :team_id, :owner_id, :story_type, :name, :slug, :description, :markdown, :users_select_array, :created_at, :updated_at, :deleted_at
  has_one :owner
  has_one :project
  has_many :comments, each_serializer: CommentSerializer
  has_many :tasks
  has_many :attachments

  delegate :users_select_array, to: :project

  def markdown
    markdownify(object.description)
  end

  def project
    object.project
  end
end
