class AddSshPreferencesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :ssh_username, :string
    add_column :users, :ssh_key, :text
  end
end
