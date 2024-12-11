class ApprovalWorkflow < ApplicationRecord
  has_many :roles, dependent: :restrict_with_error
  has_many :accesses, through: :roles

  validates :name, presence: true
  validates :primary_approver_ids, presence: true
  validates :required_primary_approvals, presence: true,
    numericality: { 
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: ->(workflow) { workflow.primary_approver_ids.size }
    }
  
  validates :required_secondary_approvals, presence: true,
    numericality: { 
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: ->(workflow) { workflow.secondary_approver_ids.size }
    }

  validate :secondary_approvals_cannot_exceed_approvers
  validate :primary_and_secondary_approvers_must_be_different

  after_update :recheck_pending_accesses

  def primary_approvers
    User.where(id: primary_approver_ids)
  end

  def secondary_approvers
    User.where(id: secondary_approver_ids)
  end

  def all_approvers
    User.where(id: all_approver_ids)
  end

  def all_approver_ids
    primary_approver_ids + secondary_approver_ids
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  # def self.ransackable_associations(auth_object = nil)
  #   %w[roles]
  # end

  private

  def secondary_approvals_cannot_exceed_approvers
    return if secondary_approver_ids.blank?
    return if required_secondary_approvals <= secondary_approver_ids.size
    
    errors.add(:required_secondary_approvals, "cannot exceed number of secondary approvers")
  end

  def primary_and_secondary_approvers_must_be_different
    return if (primary_approver_ids & secondary_approver_ids).empty?
    
    errors.add(:base, "Users cannot be both primary and secondary approvers")
  end

  def recheck_pending_accesses
    accesses.where(status: ['pending', 'pending_secondary']).find_each do |access|
      # Skip if no approvals yet
      next if access.approvals.empty?
      
      # Recheck if current approvals are sufficient under new workflow rules
      case access.status
      when 'pending'
        if access.approvals.size >= required_primary_approvals
          access.status = required_secondary_approvals.positive? ? 'pending_secondary' : 'approved'
          access.approved = true if access.status == 'approved'
          access.save
        end
      when 'pending_secondary'
        if access.approvals.size >= (required_primary_approvals + required_secondary_approvals)
          access.status = 'approved'
          access.approved = true
          access.save
        end
      end
    end
  end

end
