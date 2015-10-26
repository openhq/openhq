class ApiTokenSerializer < ActiveModel::Serializer
  attributes :token

  has_one :user, serializer: UserSerializer
  has_one :team, serializer: TeamSerializer
end
