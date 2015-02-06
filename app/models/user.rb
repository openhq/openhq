class User < ActiveRecord::Base
  ROLES = %w[user admin owner]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :created_projects, foreign_key: "owner_id", class_name: "Project"

  validates :first_name, :last_name, presence: true
  validates :role, presence: true, inclusion: {in: ROLES}

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def assignable_roles
    ROLES[0..ROLES.index(role)]
  end
end
