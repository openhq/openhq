class Project < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  has_many :stories
  has_and_belongs_to_many :users

  validates_presence_of :name, :owner_id

end
