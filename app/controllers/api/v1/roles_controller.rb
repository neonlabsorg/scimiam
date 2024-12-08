module Scim
	class Api::V1::RolesController < Scimitar::ActiveRecordBackedResourcesController

		protected

			def storage_class
				Role
			end

			def storage_scope
				Role.all
			end

	end
end