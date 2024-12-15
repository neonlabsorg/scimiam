class AddProvisioningToRoles < ActiveRecord::Migration[7.1]
  def change
    add_reference :roles, :workspace_connection, type: :uuid, foreign_key: true
    add_column :roles, :workspace_group, :string
  end
end
