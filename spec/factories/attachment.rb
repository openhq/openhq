require 'faker'

FactoryGirl.define do
  factory :attachment do
    sequence(:name) {|n| Faker::Lorem.word + " (#{n})" }
    file_path "/images/test.jpg"
    sequence(:file_name) {|n| "#{Faker::Lorem.word} (#{n}).jpg" }
    file_size "1234"
    content_type "image/jpeg"
    association :owner, factory: :user
  end
end
