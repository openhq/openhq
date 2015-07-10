class AddUserInfoFields < ActiveRecord::Migration
  def change
    add_column :users, :job_title, :string
    add_column :users, :bio, :text
    add_column :users, :skype, :string
    add_column :users, :phone, :string
  end
end
