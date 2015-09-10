class SignupForm
  include ActiveModel::Model

  attr_reader :team, :user
  attr_accessor :team_name, :subdomain, :first_name, :last_name, :username, :email, :password

  validates :subdomain, subdomain: true, presence: true
  validates :team_name, :first_name, :last_name, presence: true
  validates :email, email: true, presence: true
  validates :username, username: true, presence: true
  validates :password, presence: true, length: { minimum: 8 }
  validate :unique_attributes

  def submit(params)
    self.team_name = params[:team_name]
    self.subdomain = params[:subdomain]
    self.first_name = params[:first_name]
    self.last_name = params[:last_name]
    self.username = params[:username]
    self.email = params[:email]
    self.password = params[:password]

    @team = Team.new(name: team_name, subdomain: subdomain)
    @user = User.new(first_name: first_name, last_name: last_name, username: username, email: email, password: password)

    if valid?
      ActiveRecord::Base.transaction do
        @team.save!
        @user.save!
        @team.team_users.create!(user: @user, role: "owner")
      end

      true
    else
      false
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, @team.errors.full_messages.first) if @team.errors.any?
    errors.add(:base, @user.errors.full_messages.first) if @user.errors.any?

    false
  end

  private

  # Ensures unique subdomain, email and username
  def unique_attributes
    if Team.where(subdomain: subdomain).count > 0
      errors.add(:subdomain, "has already been taken")
    end
    if User.where(email: email).count > 0
      errors.add(:email, "has already been taken")
    end
    if User.where(username: username).count > 0
      errors.add(:username, "has already been taken")
    end
  end
end
