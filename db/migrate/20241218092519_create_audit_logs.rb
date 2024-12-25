class CreateAuditLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :audit_logs, id: :uuid do |t|
      t.text   :event

      t.timestamps
    end
  end
end
