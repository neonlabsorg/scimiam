class UsersController < ApplicationController
  before_action :authorize
  # before_action :is_admin?, only: %i[index show edit update]
  before_action :set_user, only: %i[show edit update]
  before_action :set_accesses, only: %i[show]

  def index
    search_params = params.permit(:format, :page, q: [:displayname_cont, :s])
    @q = User.select(:id, :displayname, :work_email_address).where(is_active: true).order(displayname: :asc).ransack(search_params[:q])
    users = @q.result
    @pagy, @users = pagy_countless(users, items: 50)
  end

  def show
  end

  def edit
  end

  def update
    if current_user == @user || current_user.is_admin?
      if @user.update(user_params)
        flash[:success] = "Updated"
        # render turbo_stream: turbo_stream.action(:redirect, user_path(@user))
        redirect_to root_path
      else
        flash.now[:errors] = @user.errors.full_messages
        render :edit
      end
    else
      flash[:warning] = "You are not authorized to edit this user"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :github_username
    )
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_accesses
    @accesses = Access.where(user_id: params[:id]).joins(:role).order(approved: :asc, created_at: :desc)
  end

end