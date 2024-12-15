class CreateWorkspaceConnections < ActiveRecord::Migration[7.1]
  def change
    create_table :workspace_connections, id: :uuid do |t|
      t.string :name, null: false
      t.string :domain, null: false
      t.text :credentials, null: false
      t.string :admin_email, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
