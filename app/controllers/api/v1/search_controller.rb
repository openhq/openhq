module Api
  module V1
    class SearchController < BaseController

      resource_description do
        formats ["json"]
      end

      api! "Fetchs search results"
      param :term, String, desc: "The search term", required: true
      param :limit, Integer, desc: "The number of results you want returned (default: 20)", required: false
      param :page, Integer, desc: "The page number you want returned (default: 1)", required: false
      def create
        term = params[:term]

        # Make sure a term is provided
        if term.nil?
          return render json: { message: "Validation Failed", errors: [{ field: "term", errors: ["is required"] }] }, status: 422
        end

        page = (params[:page] || 1).to_i
        limit = (params[:limit] || 20).to_i

        results = SearchDocument.search(term, current_team.id, current_user.project_ids).page(page).per(limit)

        has_more_results = (page * limit) < results.total_count
        next_url = api_v1_search_index_path(term: term, page: page+1, limit: limit) if has_more_results

        meta = {
          term: term,
          total: results.total_count,
          next_url: next_url
        }

        render json: results, meta: meta, each_serializer: SearchDocumentApiSerializer
      end
    end
  end
end
