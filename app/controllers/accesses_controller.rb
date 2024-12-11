class AccessesController < ApplicationController
  before_action :authorize
  before_action :load_roles, only: [:new]
  before_action :set_access, only: [:comment, :approve, :destroy, :comment]

  def new
    @access = Access.new
  end

  def create
    @access = Access.new(access_params)
    
    if @access.save
      flash[:success] = "Access request submitted"
      redirect_to root_path
    else
      flash[:errors] = @access.errors.full_messages
      redirect_to root_path
    end
  end

  def approve
    if @access.approve!(current_user.id)
      flash[:success] = "Access request approved"
    else
      flash[:error] = "Unable to approve access request"
    end
    redirect_to root_path
  end

  # def destroy
  #   if @access.destroy
  #     flash[:success] = "Access revoked"
  #   else
  #     flash[:error] = "Unable to revoke access"
  #   end
  #   redirect_to root_path
  # end

  def destroy
    comment = params[:access][:comment]
    access  = @access
    # if request.referer.include?('roles')
    #   # UserMailer.access_revoked(access, comment).deliver_later
    # else
    #   # UserMailer.access_declined(access, comment).deliver_later
    # end
    role = @access.role # for Trigger IAM job
    if @access.destroy
      # TriggerIamJob.perform_later(role)
      flash[:success] = "Deleted"
      redirect_back(fallback_location: root_path)
    else
      flash[:errors] = @access.errors.full_messages
      redirect_back(fallback_location: root_path)
    end
  end

  def comment
  end

  private

  def set_access
    @access = Access.find(params[:id])
  end

  def load_roles
    @roles = Role.where(is_active: true)
  end

  def access_params
    params.require(:access).permit(:role_id, :user_id, :justification)
  end
end
