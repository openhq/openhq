class AddOwnerIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :owner_id, :integer
    add_index :tasks, :owner_id
  end
end
