class AddInvitableToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      ## Invitable
      t.string   :invitation_token
      t.datetime :invitation_created_at
      t.datetime :invitation_sent_at
      t.datetime :invitation_accepted_at
      t.integer  :invitation_limit
      t.integer  :invited_by_id
      t.string   :invited_by_type
    end
    add_index :users, :invitation_token, :unique => true
    change_column :users, :username, :citext, :null => true
  end
end
