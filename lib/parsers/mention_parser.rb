class MentionParser
  def self.users(content)
    usernames = String(content).scan(/\B@[0-9a-zA-Z\-_]/).map { |u| u.gsub(/@/, '') }
    User.where("username IN (?)", usernames)
  end
end
