class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer   :user_id
      t.integer   :project_id
      t.integer   :story_id
      t.integer   :notifiable_id
      t.string    :notifiable_type
      t.string    :action_performed
      t.boolean   :send_email
      t.boolean   :delivered
      t.timestamps
    end
    add_index :notifications, :user_id

    add_column :users, :notification_frequency, :string, default: "asap"
    add_column :users, :last_notified_at, :datetime

    add_column :projects_users, :receive_notifications, :boolean, default: true
  end
end
