namespace :comments do
  desc "Sets a story id on all existing comments without one"
  task migrate_story_ids: :environment do
    Comment.where(story_id: nil).each do |comment|
      if comment.commentable_type == "Story"
        comment.update(story_id: comment.commentable_id)
      end
    end
  end
end