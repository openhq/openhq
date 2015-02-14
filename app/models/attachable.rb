class Attachable < ActiveRecord::Base
  belongs_to :attacable, polymorphic: true
  belongs_to :attachment
end
