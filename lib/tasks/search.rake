namespace :search do
  desc "Reindexes the search_documents table"
  task reindex: :environment do
    SearchDocument.delete_all

    Project.search_reindex
    Story.search_reindex
    Task.search_reindex
    Comment.search_reindex
    Attachment.search_reindex
  end
end