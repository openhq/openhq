class SearchController < ApplicationController

  def index
    @query = params[:q]
    @results = SearchDocument.search(@query, current_team.id, current_user.project_ids).page((params[:page] || 1).to_i).per(1)

    respond_to do |format|
      format.html
      format.json do
        render json: @results, meta: {
          query: @query,
          total: @results.total_count,
          has_more: @results.total_count > @results.count,
          view_more_link: search_index_path(q: @query, page: 2)
        }
      end
    end
  end

end