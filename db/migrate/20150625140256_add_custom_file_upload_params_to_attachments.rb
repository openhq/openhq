class AddCustomFileUploadParamsToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :file_path, :string
    rename_column :attachments, :attachment_file_name, :file_name
    rename_column :attachments, :attachment_file_size, :file_size
    rename_column :attachments, :attachment_content_type, :content_type
  end
end
