class AddInvitedToTeamUsers < ActiveRecord::Migration
  def change
    add_column :team_users, :invite_accepted_at, :datetime
    add_column :team_users, :invited_at, :datetime
    add_column :team_users, :invited_by, :integer
    add_column :team_users, :status, :string, null: false, default: "active"
    add_index :team_users, :status
  end
end
