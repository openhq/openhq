class InviteUserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :username
  has_many :team_invites
  has_many :team_users
  has_many :projects
end
