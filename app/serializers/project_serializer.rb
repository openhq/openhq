class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :owner_id, :created_at, :updated_at, :deleted_at, :team_id, :archived_count, :users_select_array
  has_many :users, serializer: UserSerializer
  has_many :recent_stories, serializer: ThinStorySerializer

  def recent_stories
    object.recent_stories.take(5)
  end

  def archived_count
    object.stories.only_deleted.count
  end
end
