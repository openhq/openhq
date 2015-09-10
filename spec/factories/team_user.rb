require 'faker'

FactoryGirl.define do
  factory :team_user do
    team
    user
    role { ["user", "admin", "owner"].sample }
  end
end
