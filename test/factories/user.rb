require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "testpassword1"
    password_confirmation "testpassword1"
    admin false
  end
end
