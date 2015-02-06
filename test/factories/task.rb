require 'faker'

FactoryGirl.define do
  factory :task do
    label { Faker::Lorem.sentence }
    story
  end
end
