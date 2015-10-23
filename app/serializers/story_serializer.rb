class StorySerializer < ActiveModel::Serializer
  attributes :id, :project_id, :team_id, :name, :slug, :description, :owner_id, :created_at, :updated_at, :deleted_at
  has_one :owner
end
