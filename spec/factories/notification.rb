require 'faker'

FactoryGirl.define do
  factory :notification do
    user
    action_performed { ["created", "updated", "deleted"].sample }
  end
end
