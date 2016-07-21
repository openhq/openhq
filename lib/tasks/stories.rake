namespace :stories do
  desc "Sets a story type on any stories without one"
  task migrate_story_types: :environment do
    stories = Story.where(story_type: nil)

    Rails.logger.info("="*50)
    Rails.logger.info("Migrating #{stories.count} stories...")

    stories.each do |story|
      if story.tasks.any?
        story.update(story_type: "todo")
      elsif story.attachments.any?
        story.update(story_type: "file")
      else
        story.update(story_type: "discussion")
      end
    end

    Rails.logger.info("...complete")
    Rails.logger.info("="*50)
  end
end