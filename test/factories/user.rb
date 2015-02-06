require 'faker'

FactoryGirl.define do
  factory :user do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    email { Faker::Internet.email }
    password "testpassword1"
    password_confirmation "testpassword1"
    admin false
  end
end
