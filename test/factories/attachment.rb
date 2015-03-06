require 'faker'

FactoryGirl.define do
  factory :attachment do
    name { Faker::Lorem.word }
    attachment_file_name "test.jpg"
    attachment_file_size "1234"
    attachment_content_type "image/jpeg"
    association :owner, factory: :user
  end
end
