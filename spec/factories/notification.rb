require 'faker'

FactoryGirl.define do
  factory :notification do
    user
    story
    project
    notifiable { [project, story].sample }
    action_performed { ["created", "updated", "deleted"].sample }
    seen { [true, false].sample }
  end
end
