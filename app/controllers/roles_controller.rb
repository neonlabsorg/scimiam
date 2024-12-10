class RolesController < ApplicationController
  before_action :authorize
  before_action :set_role, only: %i[show]
  before_action :set_accesses, only: %i[show]

  def index
    search_params = params.permit(:format, :page, q: [:name_cont, :s])
    @q = Role.select(:id, :name, :is_active).order(name: :asc).ransack(search_params[:q])
    roles = @q.result
    @pagy, @roles = pagy_countless(roles, items: 50)
  end

  def show
    # in role details we search over accesses
    search_params = params.permit(:id, :format, :page, q: [:user_displayname_cont, :s])
    @q = Access.where(role_id: params[:id]).ransack(search_params[:q])
    accesses = @q.result
    @pagy, @accesses = pagy_countless(accesses, items: 50)
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def set_accesses
    @accesses = Access.where(role_id: params[:id])
  end

end