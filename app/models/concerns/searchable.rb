module Searchable
  extend ActiveSupport::Concern

  included do
    has_one :search_document, as: :searchable
    after_save :index_search_document
  end

  # An array of fields to include in the searchable content
  def searchable_against
    []
  end

  # runs after save to update the searchable table
  def index_search_document
    # make sure the search document exists
    create_search_document if search_document.nil?
    # update the content
    search_document.update(content: searchable_content)
  end

  def create_search_document
    presenter = present(self)
    SearchDocument.create(
      searchable: self,
      team_id: presenter.project.team_id,
      project_id: presenter.project.id,
      story_id: presenter.story.present? ? present.story.id : nil
    )
  end

  def searchable_content
    content = ""

    # if an 'if:' was passed to the options,
    # make sure it passes before adding any more content
    if search_options[:if].present?
      return content unless send(search_options[:if])
    end

    # run through all the fields we are adding to the content
    # field and add them to the content
    Array(search_options[:against]).each do |field|
      # only take alphanumeric characters from the field
      content += String(self[field]).gsub(/[^0-9a-z ]/i, '') + " "
    end

    content
  end

  module ClassMethods
    def searchable(options = {})
      class_attribute :search_options
      self.search_options = options
    end
  end
end