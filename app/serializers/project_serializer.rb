class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :owner_id, :created_at, :updated_at, :deleted_at, :team_id
  has_many :users, serializer: UserSerializer
  has_many :stories, serializer: ThinStorySerializer

  def stories
    object.stories.order(updated_at: :desc).take(5)
  end
end
