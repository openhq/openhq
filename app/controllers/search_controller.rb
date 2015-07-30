class SearchController < ApplicationController

  def create
    redirect_to search_path(search_params[:q].to_param)
  end

  def show
    @query = params[:id]
    @results = PgSearch.multisearch(@query)
  end

  private

  def search_params
    params.require(:search).permit(:q)
  end

end