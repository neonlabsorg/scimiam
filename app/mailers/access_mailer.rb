class AccessMailer < ApplicationMailer
  def request_notification(access)
    @access = access
    @approvers = @access.role.approval_workflow.primary_approvers
    mail(to: @approvers.pluck(:work_email_address), subject: 'New Access Request')
  end

  def approval_notification(access)
    @access = access
    @requestor = @access.user
    mail(to: @requestor.work_email_address, subject: 'Your Access Request has been Approved')
  end

  def decline_notification(access)
    @access = access
    @requestor = @access.user
    mail(to: @requestor.work_email_address, subject: 'Your Access Request has been Declined')
  end
end 