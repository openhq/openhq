class MentionParser
  def self.users(content)
    usernames = String(content).scan(/\B@\w+/).map { |u| u.gsub(/@/, '') }
    User.where("username IN (?)", usernames)
  end
end