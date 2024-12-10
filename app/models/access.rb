class Access < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  validates :user_id, uniqueness: { scope: :role_id }
  
  enum status: {
    pending: 'pending',
    pending_secondary: 'pending_secondary',
    approved: 'approved'
  }

  def approve!(approver_id)
    return false unless can_approve?(approver_id)
    
    approvals << approver_id
    update_status!
    save
  end

  def can_approve?(approver_id)
    return false unless role.approver_set
    return false if approved?
    return false if approvals.include?(approver_id)

    set = role.approver_set

    case status
    when 'pending'
      set.primary_approver_ids.include?(approver_id)
    when 'pending_secondary'
      set.secondary_approver_ids.include?(approver_id)
    else
      false
    end
  end

  def pending_approvers
    return [] unless role.approver_set
    
    case status
    when 'pending'
      role.approver_set.primary_approver_ids - approvals
    when 'pending_secondary'
      role.approver_set.secondary_approver_ids - approvals
    else
      []
    end
  end

  private

  def update_status!
    set = role.approver_set
    primary_count = (approvals & set.primary_approver_ids).size
    secondary_count = (approvals & set.secondary_approver_ids).size

    if primary_count >= set.required_primary_approvals
      if set.required_secondary_approvals.zero?
        self.status = :approved
      elsif secondary_count >= set.required_secondary_approvals
        self.status = :approved
      else
        self.status = :pending_secondary
      end
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[user_id role_id status]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user role]
  end
end 