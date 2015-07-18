class RemoveMetadataTable < ActiveRecord::Migration
  def change
    drop_table :metadata
  end
end
