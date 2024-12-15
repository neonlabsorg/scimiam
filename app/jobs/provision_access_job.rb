class ProvisionAccessJob < ApplicationJob
  queue_as :default
  
  # Retry job on failure with exponential backoff
  retry_on StandardError, wait: :exponentially_longer, attempts: 3
  
  def perform(role_id = nil)
    if role_id
      # Provision specific role
      role = Role.find_by(id: role_id)
      ProvisioningService.sync_role(role) if role
    else
      # Provision all roles that have any provisioning configured
      Role.includes(:accesses, :workspace_connection)
          .where("workspace_connection_id IS NOT NULL OR active_directory_group IS NOT NULL")
          .find_each do |role|
        ProvisioningService.sync_role(role)
      end
    end
  end
end 