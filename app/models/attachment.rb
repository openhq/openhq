class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

end