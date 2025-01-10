require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Scimiam
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # SMTP configuration
    config.action_mailer.delivery_method = :smtp
    # config.action_mailer.default_url_options = { host: ENV.fetch("HOSTNAME") { "smtp.dummy.host" } }
    config.action_mailer.smtp_settings = {
      address:              ENV.fetch("SMTP_ADDRESS") { "smtp.dummy.address" },
      port:                 587,
      domain:               ENV.fetch("SMTP_DOMAIN") { "smtp.dummy.domain" },
      user_name:            ENV.fetch("SMTP_USERNAME") { "smtp.dummy.username" },
      password:             ENV.fetch("SMTP_PASSWORD") { "smtp.dummy.passport" },
      authentication:       "login",
      enable_starttls:      true,
      open_timeout:         30,
      read_timeout:         60
    }

    config.active_record.encryption.primary_key = ENV["ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY"]
    config.active_record.encryption.deterministic_key = ENV["ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY"]
    config.active_record.encryption.key_derivation_salt = ENV["ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT"]

  end
end
