class SignupForm
  include ActiveModel::Model

  attr_reader :team, :user
  attr_accessor :team_name, :subdomain, :email

  validates :subdomain, subdomain: true, presence: true
  validates :team_name, presence: true
  validates :email, email: true, presence: true
  validate :unique_attributes

  def submit(params)
    self.team_name = params[:team_name]
    self.subdomain = params[:subdomain]
    self.email = params[:email]

    @team = Team.new(name: team_name, subdomain: subdomain)
    @user = User.new(email: email, password: SecureRandom.hex(16))

    if valid?
      ActiveRecord::Base.transaction do
        @team.save!
        @user.save!(validate: false)
        @team.team_users.create!(user: @user, role: "owner")

        TeamMailer.setup(@team, @user).deliver_later
      end

      true
    else
      false
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error(e)

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
  end
end
