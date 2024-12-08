class ProfileController < ApplicationController
	before_action :authorize

	def index
		@user = current_user
	end

end