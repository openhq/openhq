require 'faker'

FactoryGirl.define do
  factory :attachment do
    name { Faker::Lorem.word }
    path { Faker::Lorem.word }
    size { Faker::Number.number(6) }
    content_type { Faker::Lorem.word }
    association :owner, factory: :user
  end
end
