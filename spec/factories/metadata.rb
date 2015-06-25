require 'faker'

FactoryGirl.define do
  factory :metadata do
    key { Faker::Internet.slug }
  end
end
