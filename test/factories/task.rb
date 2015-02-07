require 'faker'

FactoryGirl.define do
  factory :task do
    label { Faker::Lorem.sentence }
    association :owner, factory: :user
    association :assignment, factory: :user
    story
  end
end
