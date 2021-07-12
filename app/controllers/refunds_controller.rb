class RefundsController < ApplicationController
  layout "refunds/application"
  before_action :validate_session, unless: :at_the_start?

  def new
    refund_session = Session.create
    session[:refund_session_id] = refund_session.id
    redirect_to refund_path_for RefundPagesManager.first_page
  end

  def update
    resource.assign_attributes params.permit!.fetch("refunds_#{current_step}", {})

    if resource.save
      redirect_to next_page
    else
      render action: :show
    end
  end

  private

  def next_page
    if params[:return_to_review].present?
      refund_review_path
    else
      refund_path_for page_manager.forward
    end
  end

  def refund_path_for(page, options = {})
    send "refund_#{page}_path".underscore, options
  end

  def page_manager
    @page_manager ||= RefundPagesManager.new(resource: resource)
  end

  def resource
    @form ||= Form.for("refunds/#{current_step}").new(refund_session)
  end

  def current_step
    params[:page].underscore
  end

  def refund
    @refund ||= load_refund_from_session
  end

  def refund_session
    @refund_session ||= load_refund_session_from_session
  end

  def load_refund_session_from_session
    if session[:refund_session_id].present?
      Session.find_by(id: session[:refund_session_id])
    end
  end

  def load_refund_from_session
    return nil if session[:refund_id].blank?
    Refund.find_by(id: session[:refund_id])
  end

  def at_the_start?
    params[:action] == 'new'
  end

  def validate_session
    redirect_to({ action: :new }, flash: { alert: t('refunds.show.session_reloaded') }) if refund_session.nil?
  end

  helper_method :refund_path_for, :refund, :current_step, :page_manager, :resource
end
