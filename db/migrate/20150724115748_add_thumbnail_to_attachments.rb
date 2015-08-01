class AddThumbnailToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :process_data, :json, default: {}
  end
end
