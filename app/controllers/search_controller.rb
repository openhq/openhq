class SearchController < ApplicationController

  def index
    @query = params[:q]
    @results = SearchDocument.search(@query, current_team.id, current_user.project_ids).page((params[:page] || 1).to_i).per(20)

    respond_to do |format|
      format.html
      format.json { render json: @results, meta: { total: @results.total_count } }
    end
  end

end