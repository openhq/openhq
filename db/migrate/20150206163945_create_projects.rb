class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :slug
      t.integer :owner_id
      t.timestamps
    end
    add_index :projects, :owner_id
    add_index :projects, :slug, :unqiue => true
  end
end
