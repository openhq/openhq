class AddTypeToStories < ActiveRecord::Migration
  def change
    add_column :stories, :story_type, :string
  end
end
