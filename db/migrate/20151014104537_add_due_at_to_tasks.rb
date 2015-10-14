class AddDueAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :due_at, :datetime, default: nil
  end
end
