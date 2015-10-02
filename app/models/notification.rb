class Notification < ActiveRecord::Base
  belongs_to :actioner, class_name: "User"
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

  def seen!
    # mark as delievered also, to stop the user being emailed about it
    # if they have already been notified on the website
    update(seen: true, delivered: true)
  end
end
