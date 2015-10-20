class UserSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :first_name, :last_name, :username, :email, :notification_frequency, :last_notified_at, :job_title, :avatar_url, :created_at, :updated_at, :admin

  def filter(keys)
    keys.delete(:email) unless current_user?
    keys.delete(:last_notified_at) unless current_user?
    keys.delete(:notification_frequency) unless current_user?
    keys.delete(:admin) unless current_user? && object.admin?
    keys
  end

  def avatar_url
    object.avatar.url(:thumb)
  end

  private

  def current_user?
    scope == object
  end
end
