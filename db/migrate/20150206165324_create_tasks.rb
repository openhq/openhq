class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :label
      t.integer :story_id
      t.integer :assigned_to
      t.timestamps
    end
    add_index :tasks, :story_id
    add_index :tasks, :assigned_to
  end
end
