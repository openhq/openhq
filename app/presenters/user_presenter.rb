require 'digest/md5'

class UserPresenter < BasePresenter
  presents :user

  delegate :display_name, to: :user

  def avatar_link(size = 100)
    # TODO implement link to user
    h.link_to avatar(size), "#", title: user.username
  end

  def avatar(size = 100)
    # TODO implement uploadable avatars to override gravatar if exists

    url = gravatar_url(size * 2)

    h.image_tag(url, alt: user.username, class: "avatar", width: size)
  end

  def display_role
    if user.invited_to_sign_up?
      "invited"
    else
      user.role
    end
  end

  def profile_path
    h.team_path(user.username) unless pending?
  end

  def pending?
    user.invited_to_sign_up?
  end

  private

  def gravatar_url(size = 200)
    base_url = "https://www.gravatar.com/avatar/"
    opts = "?d=blank&s="

    hash = Digest::MD5.hexdigest(user.email)

    base_url + hash + opts + size.to_s
  end

end
