class CreateRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :roles, id: :uuid do |t|
      t.text :scim_uid
      t.text :displayname, null: false
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end