class StorySerializer < ActiveModel::Serializer
  embed :ids, embed_in_root: true
  attributes :id, :project_id, :team_id, :name, :slug, :description, :owner_id, :created_at, :updated_at, :deleted_at
  has_one :owner
end
