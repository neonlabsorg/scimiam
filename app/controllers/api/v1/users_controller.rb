module Scim
	class Api::V1::UsersController < Scimitar::ActiveRecordBackedResourcesController

		protected

			def storage_class
				User
			end

			def storage_scope
				User.all
			end

	end
end