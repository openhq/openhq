class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :owner_id
      t.timestamps
    end
    add_index :comments, :owner_id
  end
end
