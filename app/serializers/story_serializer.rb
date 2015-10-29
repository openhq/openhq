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

  def owner
    # if the story has been archived - object will be nil
    # this is a quick fix to stop the owner method blowing up
    object.nil? ? nil : object.owner
  end
end
