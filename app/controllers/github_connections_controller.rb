class GithubConnectionsController < ApplicationController
  before_action :authorize
  before_action :is_admin?
  before_action :set_github_connection, only: [:show, :edit, :update, :destroy]

  def index
    @github_connections = GithubConnection.all
  end

  def show
  end

  def new
    @github_connection = GithubConnection.new
  end

  def create
    @github_connection = GithubConnection.new(github_connection_params)

    if @github_connection.save
      flash[:success] = "GitHub connection created"
      redirect_to github_connections_path
    else
      flash.now[:errors] = @github_connection.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @github_connection.update(github_connection_params)
      flash[:success] = "GitHub connection updated"
      redirect_to github_connections_path
    else
      flash.now[:errors] = @github_connection.errors.full_messages
      render :edit
    end
  end

  def destroy
    @github_connection.destroy
    flash[:success] = "GitHub connection deleted"
    redirect_to github_connections_path
  end

  private

  def set_github_connection
    @github_connection = GithubConnection.find(params[:id])
  end

  def github_connection_params
    params.require(:github_connection).permit(:name, :organization, :access_token, :active)
  end
end 