class Project < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  has_many :stories

  validates_presence_of :name, :owner_id

end