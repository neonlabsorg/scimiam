class CreateGithubConnections < ActiveRecord::Migration[7.1]
  def change
    create_table :github_connections, id: :uuid do |t|
      t.string :name, null: false
      t.string :organization, null: false
      t.text :access_token, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
