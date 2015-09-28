class SearchController < ApplicationController

  def index
    @query = params[:q]
    @results = SearchDocument.search(@query, current_team.id, current_user.project_ids)

    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end

end