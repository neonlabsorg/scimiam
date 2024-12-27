class WorkspaceConnectionsController < ApplicationController
  before_action :authorize
  before_action :is_admin?
  before_action :set_workspace_connection, only: [:show, :edit, :update, :destroy]

  def index
    @workspace_connections = WorkspaceConnection.all
  end

  def show
  end

  def new
    @workspace_connection = WorkspaceConnection.new
  end

  def create
    @workspace_connection = WorkspaceConnection.new(workspace_connection_params)
    
    if @workspace_connection.save
      flash[:success] = "Google Workspace connection created"
      redirect_to workspace_connections_path
    else
      flash.now[:errors] = @workspace_connection.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @workspace_connection.update(workspace_connection_params)
      flash[:success] = "Google Workspace connection updated"
      redirect_to workspace_connections_path
    else
      flash.now[:errors] = @workspace_connection.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @workspace_connection.destroy
      flash[:success] = "Google Workspace connection deleted"
    else
      flash[:error] = @workspace_connection.errors.full_messages
    end
    redirect_to workspace_connections_path
  end

  private

  def set_workspace_connection
    @workspace_connection = WorkspaceConnection.find(params[:id])
  end

  def workspace_connection_params
    params.require(:workspace_connection).permit(:name, :domain, :admin_email, :credentials, :active)
  end
end 