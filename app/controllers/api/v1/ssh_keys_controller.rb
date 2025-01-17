class Api::V1::SshKeysController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    username = params[:username]
    user = User.find_by(ssh_username: username)

    if user
      render plain: user.ssh_key, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end
end 