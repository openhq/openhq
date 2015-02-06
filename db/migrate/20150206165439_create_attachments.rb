class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :name
      t.string :path
      t.string :size
      t.string :content_type
      t.integer :uploaded_by
      t.timestamps
    end
    add_index :attachments, :uploaded_by
  end
end
