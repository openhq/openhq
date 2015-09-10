class Team < ActiveRecord::Base
  has_many :team_users, -> { where(status: "active") }
  has_many :user_invites, -> { where(status: "invited") }, class_name: "TeamUser"
  has_many :users, through: :team_users

  def invite(user_params)
    user = User.new(user_params.merge(password: SecureRandom.hex(16)))

    transaction do
      user.save!(validate: false)
      team_users.create!(user: user, role: "user", status: "invited")
    end

    user
  end
end
