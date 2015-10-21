class UserSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :first_name, :last_name, :username, :job_title, :avatar_url

  def avatar_url
    object.avatar.url(:thumb)
  end
end
