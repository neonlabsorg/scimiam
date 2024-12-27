class ApprovalWorkflowsController < ApplicationController
  before_action :authorize
  before_action :is_admin?
  before_action :set_approval_workflow, only: [:show, :edit, :update, :destroy]
  before_action :load_user_options, only: [:new, :edit, :create, :update]

  def index
    search_params = params.permit(:format, :page, q: [:name_cont, :s])
    @q = ApprovalWorkflow.ransack(search_params[:q])
    approval_workflows = @q.result
    @pagy, @approval_workflows = pagy_countless(approval_workflows, items: 50)
  end

  def show
  end

  def new
    @approval_workflow = ApprovalWorkflow.new
  end

  def create
    @approval_workflow = ApprovalWorkflow.new(approval_workflow_params)
    if @approval_workflow.save
      flash[:success] = "Created"
      render turbo_stream: turbo_stream.action(:redirect, approval_workflows_path(@approval_workflow))
    else
      flash.now[:errors] = @approval_workflow.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @approval_workflow.update(approval_workflow_params)
      flash[:success] = "Saved"
      render turbo_stream: turbo_stream.action(:redirect, approval_workflows_path(@approval_workflow))
    else
      flash.now[:errors] = @approval_workflow.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @approval_workflow.destroy
      flash[:success] = "Deleted"
      redirect_to approval_workflows_path
    else
      flash[:errors] = @approval_workflow.errors.full_messages
      redirect_to approval_workflows_path
    end
  end

  private

  def set_approval_workflow
    @approval_workflow = ApprovalWorkflow.find(params[:id])
  end

  def load_user_options
    @user_options = User.all # Adjust this query based on your needs
  end

  def approval_workflow_params
    params.require(:approval_workflow).permit(
      :name, 
      :required_primary_approvals, 
      :required_secondary_approvals,
      primary_approver_ids: [], 
      secondary_approver_ids: []
    )
  end
  
end
