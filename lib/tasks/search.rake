namespace :search do
  desc "Reindexes the pg_search_documents table"
  task reindex: :environment do
    PgSearch::Multisearch.rebuild(Project)
    PgSearch::Multisearch.rebuild(Story)
    PgSearch::Multisearch.rebuild(Task)
    PgSearch::Multisearch.rebuild(Comment)
    PgSearch::Multisearch.rebuild(Attachment)
  end
end