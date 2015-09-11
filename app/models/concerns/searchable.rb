module Searchable
  extend ActiveSupport::Concern

  included do
    has_one :search_document, as: :searchable
    after_save :index_search_document
  end

  # runs after save to update the searchable table
  def index_search_document
    searchable = search_document

    # make sure the search document exists
    searchable = create_search_document if searchable.nil?

    # update the content
    searchable.content = searchable_content
    # update any extra fields
    Array(search_options[:with_fields]).each do |extra_field|
      searchable[extra_field] = self.send(extra_field)
    end
    # save the document
    searchable.save
  end

  def create_search_document
    p "CREATING SEARCH DOCUMENT"
    SearchDocument.create(searchable: self)
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