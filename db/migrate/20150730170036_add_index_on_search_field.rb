class AddIndexOnSearchField < ActiveRecord::Migration
  def up
    enable_extension("pg_trgm")
    execute "CREATE INDEX pg_search_documents_content ON pg_search_documents USING gin(to_tsvector('english', content));"
  end

  def down
    execute "DROP INDEX pg_search_documents_content"
  end
end
