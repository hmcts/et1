class ClaimsController < ApplicationController
  redispatch_request unless: :created?, only: [:show, :update]

  before_action :check_session_expiry, only: [:show, :update]
  before_action :sign_out_user, only: [:new]

  def new
    @claim = Claim.new
  end

  def create
    claim = Claim.create
    session[:claim_reference] = claim.reference
    redirect_to claim_path_for ClaimPagesManager.first_page
  end

  def update
    resource.assign_attributes params[current_step].permit!

    if resource.save
      redirect_to next_page
    else
      render action: :show
    end
  end

  private

  def next_page
    if params[:return_to_review].present?
      claim_review_path
    else
      claim_path_for page_manager.forward
    end
  end

  def page_manager
    @page_manager ||= ClaimPagesManager.new(resource: resource)
  end

  def resource
    @resource ||= Form.for(current_step).new(claim)
  end

  def current_step
    params[:page].underscore
  end

  def sign_out_user
    sign_out(:user)
  end

  helper_method :page_manager, :resource, :current_step
end
