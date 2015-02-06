class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.integer :project_id
      t.string :name
      t.string :slug
      t.string :description
      t.integer :created_by
      t.timestamps
    end
    add_index :stories, :project_id
    add_index :stories, :slug, :unqiue => true
  end
end
