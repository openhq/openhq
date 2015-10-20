class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :commentable_type, :commentable_id, :owner_id, :created_at, :updated_at, :team_id

  has_one :owner
end
