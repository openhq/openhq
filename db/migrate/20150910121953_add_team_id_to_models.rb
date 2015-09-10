class AddTeamIdToModels < ActiveRecord::Migration
  def change
    add_column :projects, :team_id, :integer
    add_index :projects, :team_id

    add_column :stories, :team_id, :integer
    add_index :stories, :team_id

    add_column :tasks, :team_id, :integer
    add_index :tasks, :team_id

    add_column :attachments, :team_id, :integer
    add_index :attachments, :team_id

    add_column :comments, :team_id, :integer
    add_index :comments, :team_id

    add_column :notifications, :team_id, :integer
    add_index :notifications, :team_id
  end
end
