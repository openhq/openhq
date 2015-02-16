class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.string :commentable_type
      t.integer :commentable_id
      t.integer :owner_id
      t.timestamps
    end
    add_index :comments, :commentable_id
    add_index :comments, :owner_id
  end
end
