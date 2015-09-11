class AddInvitationCodeToTeamUsers < ActiveRecord::Migration
  def change
    add_column :team_users, :invitation_code, :string
    add_index :team_users, :invitation_code, unique: true
  end
end
