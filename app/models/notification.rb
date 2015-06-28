class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :story
  belongs_to :notifiable, polymorphic: true

  scope :undelivered, -> { where(delivered: false) }

  def delivered!
    update(delivered: true)
  end
end