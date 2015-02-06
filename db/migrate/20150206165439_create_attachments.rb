class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :name
      t.string :path
      t.string :size
      t.string :content_type
      t.integer :owner_id
      t.timestamps
    end
    add_index :attachments, :owner_id
  end
end
