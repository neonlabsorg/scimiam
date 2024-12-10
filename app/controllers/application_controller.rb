class ApplicationController < ActionController::Base
  include Pagy::Backend
  layout :layout_by_resource

  protected

  def current_user
    if session[:user_id] && session[:expires_at]
      if Time.now < session[:expires_at]
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      end
    end
  end
  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end

	def layout_by_resource
    if controller_name == 'errors'
      'errors'
    elsif controller_name == 'sessions'
      'login'
    else
      'application'
    end
  end

  def unauthorized
    render json: { 'code': 401, 'status': 'unauthorized' }, status: :unauthorized
  end
end
