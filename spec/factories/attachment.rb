require 'faker'

FactoryGirl.define do
  factory :attachment do
    name { Faker::Lorem.word }
    file_path "/images/test.jpg"
    file_name { "#{Faker::Lorem.word}.jpg" }
    file_size "1234"
    content_type "image/jpeg"
    association :owner, factory: :user
  end
end
