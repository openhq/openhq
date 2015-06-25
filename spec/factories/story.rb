require 'faker'

FactoryGirl.define do
  factory :story do
    project
    name { Faker::Lorem.sentence }
    association :owner, factory: :user
  end
end
