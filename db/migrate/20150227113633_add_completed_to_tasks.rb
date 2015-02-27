class AddCompletedToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :completed, :boolean, null: false, default: false
    add_column :tasks, :completed_on, :datetime
    add_column :tasks, :completed_by, :integer
  end
end
