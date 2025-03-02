class AddGithubPropertiesToRoles < ActiveRecord::Migration[7.1]
  def change
    add_reference :roles, :github_connection, type: :uuid, foreign_key: true
    add_column :roles, :github_team, :string
  end
end
