class Attachable < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  belongs_to :attachment
end
