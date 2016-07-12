class ThinStorySerializer < ActiveModel::Serializer
  attributes :id, :story_type, :name, :slug, :updated_at
end