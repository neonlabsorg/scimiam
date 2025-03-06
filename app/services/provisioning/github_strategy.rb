module Provisioning
  class GithubStrategy < BaseStrategy
    def sync
      return unless role.github_connection&.active?  #&& role.github_organization.present?

      client = role.github_connection.client
      organization = role.github_connection.organization
      team = role.github_team

      if team.present? 
        current_members = fetch_current_org_team_members(client, organization, team)
      else
        current_members = fetch_current_org_members(client, organization)
      end

      # Retrieve excluded usernames from the Role
      excluded_usernames = role.github_excluded_accounts

      members_to_remove = current_members - approved_user_github_usernames - excluded_usernames
      members_to_add = approved_user_github_usernames - current_members + excluded_usernames

      if team.present?
        remove_org_team_members(client, organization, members_to_remove)
        add_org_team_members(client, organization, members_to_add)
      else
        remove_org_members(client, organization, members_to_remove)
        add_org_members(client, organization, members_to_add)
      end

      Rails.logger.info "Successfully synced GitHub organization #{organization} for role #{role.name}:" \
                        " Added #{members_to_add.count} members," \
                        " Removed #{members_to_remove.count} members"
    rescue Octokit::Error => e
      Rails.logger.error "Failed to sync GitHub organization for role #{role.name}: #{e.message}"
    end

    private

    def fetch_current_org_members(client, organization)
      client.organization_members(organization).map(&:login)
    rescue Octokit::NotFound
      Rails.logger.warn "Organization #{organization} not found"
      []
    end

    def fetch_current_org_team_members(client, organization, team_slug)      
      # Fetch all teams for the organization
      teams = client.org_teams(organization)

      # Find the specific team by slug
      team = teams.find { |t| t.slug == team_slug }

      if team
        # Fetch and return the team members
        client.team_members(team.id).map(&:login)
      else
        Rails.logger.warn "Team #{team_slug} not found in organization #{organization}"
        []
      end
    end

    def remove_org_members(client, organization, usernames)
      usernames.each do |username|
        client.remove_organization_member(organization, username)
        Rails.logger.info "Removed #{username} from #{organization}"
      rescue Octokit::NotFound
        Rails.logger.warn "Member #{username} already removed from #{organization}"
      rescue Octokit::Forbidden
        Rails.logger.error "Permission denied to remove #{username} from #{organization}"
      end
    end

    def add_org_members(client, organization, usernames)
      usernames.each do |username|
        client.update_organization_membership(organization, { role: "member", user: username } )
        Rails.logger.info "Added #{username} to #{organization}"
      rescue Octokit::Conflict
        Rails.logger.warn "Member #{username} already exists in #{organization}"
      rescue Octokit::Forbidden
        Rails.logger.error "Permission denied to add #{username} to #{organization}"
      end
    end

    def remove_org_team_members(client, organization, usernames)
      team_slug = role.github_team
      team = client.org_teams(organization).find { |t| t.slug == team_slug }

      usernames.each do |username|
        begin
          if team
            client.remove_team_member(team.id, username)
            Rails.logger.info "Removed #{username} from team #{team_slug} in organization #{organization}"
          else
            Rails.logger.warn "Team #{team_slug} not found in organization #{organization}"
          end
        rescue Octokit::NotFound
          Rails.logger.warn "Member #{username} not found in team #{team_slug} of organization #{organization}"
        rescue Octokit::Forbidden
          Rails.logger.error "Permission denied to remove #{username} from team #{team_slug} in organization #{organization}"
        end
      end
    end

    def add_org_team_members(client, organization, usernames)
      team_slug = role.github_team
      team = client.org_teams(organization).find { |t| t.slug == team_slug }

      usernames.each do |username|
        begin
          if team
            client.add_team_member(team.id, username)
            Rails.logger.info "Added #{username} to team #{team_slug} in organization #{organization}"
          else
            Rails.logger.warn "Team #{team_slug} not found in organization #{organization}"
          end
        rescue Octokit::Conflict
          Rails.logger.warn "Member #{username} already exists in team #{team_slug} of organization #{organization}"
        rescue Octokit::Forbidden
          Rails.logger.error "Permission denied to add #{username} to team #{team_slug} in organization #{organization}"
        end
      end
    end
  end
end 