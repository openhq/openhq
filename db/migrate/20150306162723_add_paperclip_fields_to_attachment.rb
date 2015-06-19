class AddPaperclipFieldsToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :attachment_file_name, :string
    add_column :attachments, :attachment_file_size, :integer
    add_column :attachments, :attachment_content_type, :string
    remove_column :attachments, :path
    remove_column :attachments, :size
    remove_column :attachments, :content_type
  end
end
