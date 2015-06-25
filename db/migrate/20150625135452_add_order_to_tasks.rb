class AddOrderToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :order, :integer
  end
end
