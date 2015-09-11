class SearchDocument < ActiveRecord::Base
  belongs_to :searchable, polymorphic: true

  def self.search(query, team_id)
     where(team_id: team_id)
    .joins('INNER JOIN (SELECT "search_documents"."id" AS search_id, (ts_rank((to_tsvector(\'english\', coalesce("search_documents"."content"::text, \'\'))), (to_tsquery(\'english\', \'\'\' \' || \'' + query + '\' || \' \'\'\' || \':*\')), 0)) AS rank FROM "search_documents" WHERE (((to_tsvector(\'english\', coalesce("search_documents"."content"::text, \'\'))) @@ (to_tsquery(\'english\', \'\'\' \' || \'' + query + '\' || \' \'\'\' || \':*\'))) OR ((coalesce("search_documents"."content"::text, \'\')) % \'' + query + '\')) ) search_search_documents ON "search_documents"."id" = search_search_documents.search_id')
    .order('search_search_documents.rank DESC, updated_at DESC')
  end
end