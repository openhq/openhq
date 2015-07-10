class MentionParser
  def self.users(content)
    return unless content.present?

    usernames = content.scan(/\B@\w+/).map { |u| u.gsub(/@/, '') }
    User.where("username IN (?)", usernames) if usernames.any?
  end
end