class CurrentUserSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :first_name, :last_name, :username, :email, :notification_frequency, :last_notified_at, :job_title, :skype, :bio, :phone, :avatar_url, :created_at, :updated_at, :admin

  def filter(keys)
    keys.delete(:admin) unless object.admin?
    keys
  end

  def avatar_url
    if object.avatar_file_name.present?
      object.avatar.url(:thumb)
    else
      gravatar_url
    end
  end

  def gravatar_url(size = 200)
    base_url = "https://www.gravatar.com/avatar/"
    opts = "?d=blank&s="

    hash = Digest::MD5.hexdigest(object.email)

    base_url + hash + opts + size.to_s
  end
end
