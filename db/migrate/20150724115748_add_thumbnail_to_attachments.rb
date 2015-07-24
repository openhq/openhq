class AddThumbnailToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :thumbnail, :string, default: nil
  end
end
