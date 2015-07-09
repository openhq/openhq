require 'faker'
require 'set'

FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { unique_username }
    email { Faker::Internet.email }
    password "testpassword1"
    password_confirmation "testpassword1"
    role { ["user", "admin", "owner"].sample }
  end
end

$taken_usernames = Set.new

def unique_username
  username = nil
  loop do
    username = Faker::Internet.user_name(nil, %w[-_]).downcase[0..17]
    next if $taken_usernames.include?(username)
    break
  end
  username
end
