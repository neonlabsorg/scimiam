module Provisioning
  class GoogleWorkspaceStrategy < BaseStrategy
    def sync
      return unless role.workspace_connection&.active? && role.workspace_group.present?

      client = role.workspace_connection.client
      group_email = role.workspace_group

      current_members = fetch_current_members(client, group_email)
      
      members_to_remove = current_members - approved_user_emails
      members_to_add = approved_user_emails - current_members

      remove_members(client, group_email, members_to_remove)
      add_members(client, group_email, members_to_add)

      Rails.logger.info "Successfully synced Google Workspace group #{group_email} for role #{role.name}:" \
                       " Added #{members_to_add.count} members," \
                       " Removed #{members_to_remove.count} members"
    rescue Google::Apis::Error => e
      Rails.logger.error "Failed to sync Google Workspace group for role #{role.name}: #{e.message}"
    end

    private

    def fetch_current_members(client, group_email)
      members = []
      page_token = nil

      loop do
        response = client.list_members(
          group_email,
          page_token: page_token,
          fields: 'members(email),nextPageToken'
        )
        
        break if response.members.nil?
        
        members.concat(response.members.map(&:email))
        
        page_token = response.next_page_token
        break if page_token.nil?
      end

      members
    rescue Google::Apis::ClientError => e
      if e.status_code == 404
        Rails.logger.warn "Group #{group_email} not found"
        return []
      end
      raise
    end

    def remove_members(client, group_email, emails)
      emails.each do |email|
        client.delete_member(group_email, email)
        Rails.logger.info "Removed #{email} from #{group_email}"
      rescue Google::Apis::ClientError => e
        if e.status_code == 404
          Rails.logger.warn "Member #{email} already removed from #{group_email}"
        else
          raise
        end
      end
    end

    def add_members(client, group_email, emails)
      emails.each do |email|
        member = Google::Apis::AdminDirectoryV1::Member.new(
          email: email,
          role: 'MEMBER'
        )
        
        client.insert_member(group_email, member)
        Rails.logger.info "Added #{email} to #{group_email}"
      rescue Google::Apis::ClientError => e
        if e.status_code == 409
          Rails.logger.warn "Member #{email} already exists in #{group_email}"
        else
          raise
        end
      end
    end
  end
end