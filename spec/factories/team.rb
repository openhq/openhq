require 'faker'

FactoryGirl.define do
  factory :team do
    name { Faker::Company.name }
    sequence(:subdomain) {|n| "fake-team-#{n}" }
  end
end
