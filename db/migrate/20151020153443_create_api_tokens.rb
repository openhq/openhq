class CreateApiTokens < ActiveRecord::Migration
  def change
    create_table :api_tokens do |t|
      t.references :user, index: true, foreign_key: true
      t.references :team, index: true, foreign_key: true
      t.datetime :revoked_at
      t.string :token, null: false

      t.timestamps null: false
    end

    add_index :api_tokens, :token, unique: true
  end
end
