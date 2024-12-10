class ApproverSetsController < ApplicationController
  before_action :authorize
  before_action :set_approver_set, only: [:show, :edit, :update, :destroy]
  before_action :load_user_options, only: [:new, :edit, :create, :update]

  def index
    search_params = params.permit(:format, :page, q: [:name_cont, :s])
    @q = ApproverSet.ransack(search_params[:q])
    approver_sets = @q.result
    @pagy, @approver_sets = pagy_countless(approver_sets, items: 50)
  end

  def show
  end

  def new
    @approver_set = ApproverSet.new
  end

  def create
    @approver_set = ApproverSet.new(approver_set_params)
    if @approver_set.save
      flash[:success] = "Created"
      render turbo_stream: turbo_stream.action(:redirect, approver_sets_path(@approver_set))
    else
      flash.now[:errors] = @approver_set.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @approver_set.update(approver_set_params)
      flash[:success] = "Saved"
      render turbo_stream: turbo_stream.action(:redirect, approver_sets_path(@approver_set))
    else
      flash.now[:errors] = @approver_set.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @approver_set.destroy
      flash[:success] = "Deleted"
      redirect_to approver_sets_path
    else
      flash[:errors] = @approver_set.errors.full_messages
      redirect_to approver_sets_path
    end
  end

  private

  def set_approver_set
    @approver_set = ApproverSet.find(params[:id])
  end

  def load_user_options
    @user_options = User.all # Adjust this query based on your needs
  end

  def approver_set_params
    params.require(:approver_set).permit(
      :name, 
      :required_primary_approvals, 
      :required_secondary_approvals,
      primary_approver_ids: [], 
      secondary_approver_ids: []
    )
  end
  
end
