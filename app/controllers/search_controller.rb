class SearchController < ApplicationController

  def index
    @query = params[:q]
    @results = results_for_current_user(@query)
  end

  private

  def results_for_current_user(query)
    results = PgSearch.multisearch(@query)
    project_ids = current_user.projects.pluck(:id)

    results = results.map do |result|
      item = result.searchable
      project_id_for(item).in?(project_ids) ? item : nil
    end

    results.compact
  end

  def project_id_for(item)
    case item.class.to_s
    when "Project"
      item.id
    when "Story"
      item.project.id
    when "Comment"
      item.commentable.project.id
    when "Task"
      item.story.project.id
    when "Attachment"
      item.story.project.id
    end
  end

end