class InviteUserSerializer < ActiveModel::Serializer
  attributes :id, :email
  has_many :team_invites
  has_many :team_users
end
