class SearchDocument < ActiveRecord::Base
  belongs_to :searchable, polymorphic: true

  belongs_to :team
  belongs_to :project
  belongs_to :story

  # cant quite believe that sql is working...
  def self.search(query, team_id, project_ids)
    query.gsub!(/[^a-z0-9\s]/i, "")

    sql = ActiveRecord::Base.sanitize_sql_array(['
      INNER JOIN (SELECT
        "search_documents"."id" AS search_id,
        (ts_rank((to_tsvector(\'english\', coalesce("search_documents"."content"::text, \'\'))),
        (to_tsquery(\'english\', \'\'\' \' || :query || \' \'\'\' || \':*\')), 0)) AS rank
      FROM "search_documents"
      WHERE (((to_tsvector(\'english\', coalesce("search_documents"."content"::text, \'\'))) @@
        (to_tsquery(\'english\', \'\'\' \' || :query || \' \'\'\' || \':*\'))) OR
        ((coalesce("search_documents"."content"::text, \'\')) % :query)) ) search_search_documents ON
      "search_documents"."id" = search_search_documents.search_id
    ', query: query])

    where('team_id = ? AND project_id in (?)', team_id, project_ids)
      .joins(sql)
      .order('search_search_documents.rank DESC, updated_at DESC')
      .includes(:project, :story)
  end
end
