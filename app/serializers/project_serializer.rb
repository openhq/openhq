class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :owner_id, :created_at, :updated_at, :deleted_at, :team_id
  has_many :users
  has_many :stories
end
