class AuditLogsController < ApplicationController
  before_action :authorize
  before_action :is_admin?

  def index
    search_params = params.permit(:format, :page, q: [:event_cont, :s])

    @q = AuditLog.all.order(created_at: :desc).ransack(search_params[:q])

    audit_logs = @q.result
    @pagy, @audit_logs = pagy_countless(audit_logs, items: 50)
  end

end