class AddClearanceToUsers < ActiveRecord::Migration
  def self.up
    change_table :users  do |t|
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128
    end

    add_index :users, :remember_token

    # Remove devise related columns
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at
    remove_column :users, :sign_in_count
    remove_column :users, :current_sign_in_at
    remove_column :users, :last_sign_in_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip
    remove_column :users, :failed_attempts
    remove_column :users, :unlock_token
    remove_column :users, :locked_at
    remove_column :users, :role
    remove_column :users, :invited_by
    remove_column :users, :invitation_token
    remove_column :users, :invitation_created_at
    remove_column :users, :invitation_sent_at
    remove_column :users, :invitation_accepted_at
    remove_column :users, :invitation_limit
    remove_column :users, :invited_by_id
    remove_column :users, :invited_by_type

    users = select_all("SELECT id FROM users WHERE remember_token IS NULL")

    users.each do |user|
      update <<-SQL
        UPDATE users
        SET remember_token = '#{Clearance::Token.new}'
        WHERE id = '#{user['id']}'
      SQL
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :confirmation_token,:remember_token
    end
  end
end
