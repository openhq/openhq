class UserSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :first_name, :last_name, :username, :email, :notification_frequency, :last_notified_at, :job_title, :avatar_url, :created_at, :updated_at

  def avatar_url
    object.avatar.url(:thumb)
  end
end
