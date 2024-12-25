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
    @access.performed_by = current_user
    if @access.approve!(current_user.id)
      flash[:success] = "Access request approved"
    else
      flash[:error] = "Unable to approve access request"
    end
    redirect_to root_path
  end

  def destroy
    @access.performed_by = current_user
    comment = params[:access][:comment]
    access  = @access

    if @access.destroy
      if request.referer.include?('roles')
        # UserMailer.access_revoked(access, comment).deliver_later
        # Log the access revocation event
        AuditLog.create(event: "Access role #{access.role.name} revoked for #{access.user.displayname} by #{current_user.displayname} with comment: #{comment}")
        flash[:success] = "Revoked"
      else
        # UserMailer.access_declined(access, comment).deliver_later
        # Log the access revocation event
        AuditLog.create(event: "Access role #{access.role.name} declined for #{access.user.displayname} by #{current_user.displayname} with comment: #{comment}")
        flash[:success] = "Declined"
      end
      redirect_back(fallback_location: root_path)
    else
      flash[:errors] = @access.errors.full_messages
      redirect_back(fallback_location: root_path)
    end
  end

  def comment
    respond_to do |format|
      format.turbo_stream # This will render comment.turbo_stream.erb
      # format.html { render :comment } # Fallback for HTML requests
    end
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
