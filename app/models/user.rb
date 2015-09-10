class User < ActiveRecord::Base
  include Clearance::User

  NOTIFICATION_FREQUENCIES = %w(asap hourly daily never)

  has_many :created_projects, foreign_key: "owner_id", class_name: "Project"
  has_many :stories, foreign_key: "owner_id", class_name: "Story"
  has_many :notifications, -> { order(created_at: :asc) }
  has_many :team_users
  has_many :teams, through: :team_users

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

  # Overide devise finder to lookup by username or email
  # def self.find_for_database_authentication(warden_conditions)
  #   conditions = warden_conditions.dup
  #   if login = conditions.delete(:login)
  #     where(conditions.to_h).where(["username = :value OR email = :value", { value: login }]).first
  #   else
  #     where(conditions.to_h).first
  #   end
  # end

  def self.all_cache_key
    max_updated_at = maximum(:updated_at).try(:utc).try(:to_s, :number)
    "user/all/#{max_updated_at}"
  end

  def self.notification_frequencies
    NOTIFICATION_FREQUENCIES
  end

  def active_for_authentication?
    super && deleted_at.nil?
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
