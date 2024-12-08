class CreateAccesses < ActiveRecord::Migration[7.1]
  def change
    create_table :accesses, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :role, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end

    add_index :accesses, [:user_id, :role_id], unique: true
  end
end