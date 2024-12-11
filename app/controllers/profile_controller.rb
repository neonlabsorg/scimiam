class ProfileController < ApplicationController
	before_action :authorize
	before_action :load_pending_requests, only: [:index]
	before_action :set_accesses, only: %i[index]

	def index
	end

	private

  def set_accesses
    # all access roles for current_user
    @accesses = Access.where(user: current_user).joins(:role).order(approved: :asc, created_at: :desc)
  end

	def load_pending_requests
		# Get all accesses where current user is an approver
		@requests = Access.includes(:user, :role)
						 .joins(role: :approval_workflow)
						 .where("? = ANY(approval_workflows.primary_approver_ids) OR ? = ANY(approval_workflows.secondary_approver_ids)", 
								 current_user.id, current_user.id)
						 .where.not(status: 'approved')
						 .where.not(user_id: current_user.id)
						 .select { |access| access.can_approve?(current_user.id) }
	end
end