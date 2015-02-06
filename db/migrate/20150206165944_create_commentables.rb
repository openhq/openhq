class CreateCommentables < ActiveRecord::Migration
  def change
    create_table :commentables do |t|
      t.integer :comment_id
      t.string :commentable_type
      t.integer :commentable_id
    end
    add_index :commentables, :commentable_id
  end
end
