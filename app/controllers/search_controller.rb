class SearchController < ApplicationController

  def index
    @query = params[:q]
    @results = SearchDocument.search(@query, current_team.id)
  end

end