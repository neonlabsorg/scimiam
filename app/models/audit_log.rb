class AuditLog < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["event"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

end