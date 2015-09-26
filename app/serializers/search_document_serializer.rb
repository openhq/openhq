class SearchDocumentSerializer < ActiveModel::Serializer
  attributes :searchable_type, :searchable, :project, :story

  def project
    searchable.respond_to?(:project) ? searchable.project : nil
  end

  def story
    searchable.respond_to?(:story) ? searchable.story : nil
  end
end