require 'faker'

FactoryGirl.define do
  factory :team do
    name { Faker::Company.name }
    sequence(:subdomain) {|n| "fake_team_#{n}" }
  end
end
