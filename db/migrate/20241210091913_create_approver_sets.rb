class CreateApproverSets < ActiveRecord::Migration[7.1]
  def change
    create_table :approver_sets, id: :uuid do |t|
      t.string :name, null: false
      t.uuid :primary_approver_ids, array: true, default: []
      t.uuid :secondary_approver_ids, array: true, default: []
      t.integer :required_primary_approvals, default: 1
      t.integer :required_secondary_approvals, default: 0

      t.timestamps
    end

    add_reference :roles, :approver_set, type: :uuid, foreign_key: true
  end
end