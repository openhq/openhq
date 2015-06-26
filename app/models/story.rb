class Story < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :project, touch: true
  belongs_to :owner, class_name: "User"
  has_many :tasks, -> { order(completed: :asc, order: :asc, created_at: :asc) }
  has_many :attachments
  has_many :comments, as: :commentable
  has_many :users, through: :comments, source: :owner

  validates_presence_of :project_id, :name, :owner_id

  scope :recent, -> { order(updated_at: :desc) }

  def collaborators
    (users + [owner]).uniq
  end

  def users_select_array
    @users_select_array ||= [['unassigned', 0]].concat(project.users.active.map {|u| [u.username, u.id]})
  end
end
