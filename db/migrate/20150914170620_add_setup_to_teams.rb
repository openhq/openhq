class AddSetupToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :setup_code, :string
    add_index :teams, :setup_code, unique: true
    add_column :teams, :setup_completed_at, :datetime
    add_column :teams, :setup_completed_by, :integer
  end
end
