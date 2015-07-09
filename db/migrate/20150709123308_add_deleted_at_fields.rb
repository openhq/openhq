class AddDeletedAtFields < ActiveRecord::Migration
  def change
    add_column :projects, :deleted_at, :datetime
    add_index :projects, :deleted_at

    add_column :stories, :deleted_at, :datetime
    add_index :stories, :deleted_at
  end
end
