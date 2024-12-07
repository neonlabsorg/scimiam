# SCIMITAR CONFIGURATION
# See https://github.com/RIPAGlobal/scimitar/blob/main/config/initializers/scimitar.rb

Rails.application.config.to_prepare do
	# ===========================================================================
	# SERVICE PROVIDER CONFIGURATION
	# ===========================================================================
	Scimitar.service_provider_configuration = Scimitar::ServiceProviderConfiguration.new({
		authenticationSchemes: [
			Scimitar::AuthenticationScheme.bearer
		]
	})

	# ===========================================================================
	# ENGINE CONFIGURATION
	# ===========================================================================
	Scimitar.engine_configuration = Scimitar::EngineConfiguration.new({
		# Support HTTP bearer token (OAuth-style) authentication:
		token_authenticator: Proc.new do | token, options |
			secret = ENV["SCIM_API_TOKEN"]
			
			ActiveSupport::SecurityUtils.secure_compare(token, secret)
		end
	})

end