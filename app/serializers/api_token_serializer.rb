class ApiTokenSerializer < ActiveModel::Serializer
  has_one :user, serializer: UserSerializer
  has_one :team, serializer: TeamSerializer

  attributes :user, :team, :token
end
