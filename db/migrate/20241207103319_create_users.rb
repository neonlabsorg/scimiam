class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.timestamps

      t.text      :scim_uid
      t.text      :username, null: false
      t.text      :displayname
      t.text      :first_name
      t.text      :last_name
      t.text      :work_email_address
      t.boolean   :is_active, default: true

    end
  end
end
