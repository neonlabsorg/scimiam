class GithubConnection < ApplicationRecord
  encrypts :access_token

  validates :name, presence: true
  validates :organization, presence: true
  validates :access_token, presence: true

  def client
    @client ||= Octokit::Client.new(access_token: access_token)
  end

  # def collaborators
  #   client.collaborators(organization)
  # rescue Octokit::NotFound
  #   []
  # end

end