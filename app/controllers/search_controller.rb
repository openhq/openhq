class SearchController < ApplicationController

  def index
    @query = params[:q]
    @results = PgSearch.multisearch(@query)
  end

end