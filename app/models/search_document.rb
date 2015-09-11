class SearchDocument < ActiveRecord::Base
  belongs_to :searchable, polymorphic: true
end