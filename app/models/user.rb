class User < ActiveRecord::Base
  ROLES = %w[user admin owner]

  attr_accessor :login # username or email

  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :created_projects, foreign_key: "owner_id", class_name: "Project"
  has_many :stories, foreign_key: "owner_id", class_name: "Story"

  has_and_belongs_to_many :projects

  validates :first_name, :last_name, presence: true
  validates :role, presence: true, inclusion: {in: ROLES}
  validates :username,
    username: true,
    presence: true,
    uniqueness: {
      case_sensitive: false
    }

  # Overide devise finder to lookup by username or email
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["username = :value OR email = :value", { :value => login }]).first
    else
      where(conditions.to_h).first
    end
  end

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def assignable_roles
    ROLES[0..ROLES.index(role)]
  end
end
