class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :story
  belongs_to :notifiable, polymorphic: true

  acts_as_tenant(:team)

  scope :undelivered, -> { where(delivered: false) }
  scope :unseen, -> { where(seen: false) }

  def delivered!
    update(delivered: true)
  end

  def mark_as_seen
    update(seen: true)
  end
end
