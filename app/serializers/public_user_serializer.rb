class PublicUserSerializer < ActiveModel::Serializer
  attributes :id, :username, :name, :email, :gravatar_url

  def name
    object.display_name
  end

  def gravatar_url
    base_url = "//www.gravatar.com/avatar/"
    hash = Digest::MD5.hexdigest(object.email)
    base_url + hash
  end
end
