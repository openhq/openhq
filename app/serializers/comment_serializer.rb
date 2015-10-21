class CommentSerializer < ActiveModel::Serializer
  include TagHelper

  attributes :id, :content, :markdown, :commentable_type, :commentable_id, :owner_id, :created_at, :updated_at, :team_id

  has_one :owner

  def markdown
    markdownify(object.content)
  end
end
