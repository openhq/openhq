class Commentable < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :comment
end
