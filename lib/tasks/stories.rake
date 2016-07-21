namespace :stories do
  desc "Sets a story type on any stories without one"
  task migrate_story_types: :environment do
    Story.where(story_type: nil).each do |story|
      if story.tasks.any?
        story.update(story_type: "todo")
      elsif story.attachments.any?
        story.update(story_type: "file")
      else
        story.update(story_type: "discussion")
      end
    end
  end
end