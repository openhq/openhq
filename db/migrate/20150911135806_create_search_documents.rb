class CreateSearchDocuments < ActiveRecord::Migration
  def up
    create_table :search_documents do |t|
      t.belongs_to :searchable, polymorphic: true, index: true
      t.integer :team_id, index: true
      t.integer :project_id, index: true
      t.integer :story_id, index: true
      t.text :content

      t.timestamps
    end
    execute "CREATE INDEX search_documents_content ON search_documents USING gin(to_tsvector('english', content));"
  end

  def down
    drop_table :search_documents
    execute "DROP INDEX search_documents_content"
  end
end
