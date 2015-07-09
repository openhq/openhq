require 'faker'

FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence {|n| "user_#{1}" }
    email { Faker::Internet.email }
    password "testpassword1"
    password_confirmation "testpassword1"
    role { ["user", "admin", "owner"].sample }
  end
end
