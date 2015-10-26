class StorySerializer < ActiveModel::Serializer
  include TagHelper

  attributes :id, :project_id, :team_id, :name, :slug, :description, :markdown, :owner_id, :created_at, :updated_at, :deleted_at
  has_one :owner, embed: :id, embed_in_root: true

  def markdown
    markdownify(object.description)
  end

  def owner
    # if the story has been archived - object will be nil
    # this is a quick fix to stop the owner method blowing up
    object.nil? ? nil : object.owner
  end
end
