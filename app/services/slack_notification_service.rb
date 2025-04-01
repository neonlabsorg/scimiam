require 'net/http'
require 'uri'
require 'json'

class SlackNotificationService
  def self.notify(payload)
    return unless webhook_url.present?

    begin
      uri = URI.parse(webhook_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      request.body = payload.to_json

      response = http.request(request)
      Rails.logger.info "Slack notification sent. Response: #{response.code}"
    rescue => e
      Rails.logger.error "Failed to send Slack notification: #{e.message}"
    end
  end

  private

  def self.webhook_url
    ENV['SLACK_WEBHOOK_URL']
  end
end 