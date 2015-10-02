class AddActionerIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :actioner_id, :integer
  end
end
