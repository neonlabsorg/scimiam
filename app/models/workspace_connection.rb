class WorkspaceConnection < ApplicationRecord
  encrypts :credentials
  
  validates :name, presence: true
  validates :domain, presence: true
  validates :credentials, presence: true
  validates :admin_email, presence: true

  def client
    @client ||= begin
      service = Google::Apis::AdminDirectoryV1::DirectoryService.new
      service.authorization = authorize_service
      service
    end
  end

  private

  def authorize_service
    creds_json = JSON.parse(credentials)
    scopes = ['https://www.googleapis.com/auth/admin.directory.group']

    Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(creds_json.to_json),
      scope: scopes
    ).tap do |creds|
      creds.sub = admin_email
    end
  end
end 