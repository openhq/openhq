class User < ActiveRecord::Base
  include Clearance::User

  NOTIFICATION_FREQUENCIES = %w(asap hourly daily never)

  attr_accessor :role

  has_many :team_users, -> { where(status: "active") }
  has_many :team_invites, -> { where(status: "invited") }, class_name: "TeamUser"
  has_many :teams, through: :team_users
  has_many :created_projects, foreign_key: "owner_id", class_name: "Project"
  has_many :stories, foreign_key: "owner_id", class_name: "Story"
  has_many :tasks, foreign_key: "assigned_to"
  has_many :notifications, -> { order(created_at: :desc).includes(:story, :project, :team) }

  has_and_belongs_to_many :projects, -> { order(name: :asc) }

  has_attached_file :avatar, styles: { thumb: "300x300#" }
  validates_attachment_content_type :avatar, content_type: %r{^image\/}

  validates :first_name, :last_name, presence: true
  validates :notification_frequency, presence: true, inclusion: {in: NOTIFICATION_FREQUENCIES}
  validates :username,
    username: true,
    presence: true,
    uniqueness: {
      case_sensitive: false
    }

  scope :active, -> { not_deleted }
  scope :not_deleted, -> { where("deleted_at IS NULL") }

  def self.all_cache_key
    max_updated_at = maximum(:updated_at).try(:utc).try(:to_s, :number)
    "user/all/#{max_updated_at}"
  end

  def self.notification_frequencies
    NOTIFICATION_FREQUENCIES
  end

  # Overide clearance method to notify user of password change
  def update_password(new_password)
    super(new_password).tap do |status|
      UserMailer.password_changed(self).deliver_later if status
    end
  end

  def update_with_password(user_params)
    if authenticated?(user_params[:current_password])
      update(user_params.except(:current_password))
    else
      errors.add(:base, "Your current password was incorrect")
      false
    end
  end

  def display_name
    full_name.presence || username.presence || email
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def due_email_notification?
    case notification_frequency
    when "asap"
      true
    when "hourly"
      last_notified_at < (Time.zone.now - 1.hour)
    when "daily"
      last_notified_at < (Time.zone.now - 1.day)
    else
      false
    end
  end
end
