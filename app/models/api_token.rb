class ApiToken < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  validates :user, :team, presence: true

  before_create :generate_unique_token

  def self.for(user, team)
    where(user: user, team: team, revoked_at: nil).first_or_create!
  end

  private

  def generate_unique_token
    self.token = SecureRandom.hex(32)
  end
end
