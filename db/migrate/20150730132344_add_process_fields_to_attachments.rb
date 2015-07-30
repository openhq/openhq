class AddProcessFieldsToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :process_attempts, :integer, default: 0
    add_column :attachments, :processed_at, :datetime, default: nil
  end
end
