class CreateAttachables < ActiveRecord::Migration
  def change
    create_table :attachables do |t|
      t.integer :attachment_id
      t.string :attachable_type
      t.integer :attachable_id
    end
    add_index :attachables, :attachable_id
  end
end
