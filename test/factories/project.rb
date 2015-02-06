require 'faker'

FactoryGirl.define do
  factory :project do
    name { Faker::Company.name }
    association :owner, factory: :user
  end
end
