class SearchController < ApplicationController

  def index
    @query = params[:q]
    page = (params[:page] || 1).to_i
    limit = 20

    @results = SearchDocument.search(@query, current_team.id, current_user.project_ids).page(page).per(limit)

    @start = (page - 1) * limit + 1
    @end = page * limit
    @end = @results.total_count if @end > @results.total_count

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