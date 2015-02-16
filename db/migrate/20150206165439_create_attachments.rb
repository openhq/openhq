class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :name
      t.string :path
      t.string :size
      t.string :content_type
      t.string :attachable_type
      t.integer :attachable_id
      t.integer :story_id
      t.integer :owner_id
      t.timestamps
    end
    add_index :attachments, :owner_id
    add_index :attachments, :attachable_id
    add_index :attachments, :story_id
  end
end
