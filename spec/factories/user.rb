require 'faker'

FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:username) {|n| "fake_user_#{n}" }
    email { Faker::Internet.email }
    password "testpassword1"

    factory :user_with_team do
      after(:create) do |user|
        team = FactoryGirl.create(:team)
        team.team_users.create!(user: user, role: "owner")
      end
    end
  end
end
