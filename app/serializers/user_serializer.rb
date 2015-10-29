class UserSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :first_name, :last_name, :username, :job_title, :avatar_url

  def avatar_url
    if object.avatar_file_name.present?
      object.avatar.url(:thumb)
    else
      gravatar_url(60)
    end
  end

  def gravatar_url(size)
    base_url = "https://www.gravatar.com/avatar/"
    opts = "?d=blank&s="

    hash = Digest::MD5.hexdigest(object.email)

    base_url + hash + opts + size.to_s
  end
end
