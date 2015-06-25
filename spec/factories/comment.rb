require 'faker'

FactoryGirl.define do
  factory :comment do
    content { Faker::Lorem.paragraph }
    association :owner, factory: :user
  end
end
