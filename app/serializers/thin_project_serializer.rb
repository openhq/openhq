class ThinProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :updated_at
end
