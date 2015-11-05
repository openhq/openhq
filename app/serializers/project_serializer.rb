class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :owner_id, :created_at, :updated_at, :deleted_at, :team_id, :archived_count
  has_many :users, serializer: UserSerializer
  has_many :recent_stories, serializer: ThinStorySerializer

  def archived_count
    object.stories.only_deleted.count
  end
end
