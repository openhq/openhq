class CommentSerializer < ActiveModel::Serializer
  include TagHelper

  attributes :id, :content, :markdown, :commentable_type, :commentable_id, :owner_id, :created_at, :updated_at, :team_id, :owner, :attachments

  def owner
    ActiveModel::SerializableResource.new(object.owner).serializable_hash[:user]
  end

  def attachments
    object.attachments.map do |a|
      ActiveModel::SerializableResource.new(a).serializable_hash[:attachment]
    end
  end

  def markdown
    markdownify(object.content)
  end
end
