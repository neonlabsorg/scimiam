class ProvisioningService
  STRATEGIES = {
    google_workspace: Provisioning::GoogleWorkspaceStrategy,
    active_directory: Provisioning::ActiveDirectoryStrategy,
    github: Provisioning::GithubStrategy
  }.freeze

  def self.sync_role(role)
    new(role).sync
  end

  def initialize(role)
    @role = role
  end

  def sync
    applicable_strategies.each do |strategy|
      strategy.new(@role).sync
    rescue StandardError => e
      Rails.logger.error "Error in #{strategy} for role #{@role.name}: #{e.message}"
    end
  end

  private

  def applicable_strategies
    strategies = []

    # Add Google Workspace strategy if configured
    if @role.workspace_connection_id.present? && @role.workspace_group.present?
      strategies << STRATEGIES[:google_workspace]
    end

    # Add GitHub strategy if configured
    if @role.github_connection_id.present?
      strategies << STRATEGIES[:github]
    end

    strategies
  end
end