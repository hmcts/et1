class DiversitiesController < ApplicationController
  MyForm = Struct.new(:form_name)
  layout "diversities/application"

  before_action :validate_session, unless: :at_the_start?, except: [:index]
  skip_after_action :set_session_expiry, except: :new

  def new
    diversity_session = Session.create
    session[:diversity_session_id] = diversity_session.id
    redirect_to diversity_path_for DiversityPagesManager.first_page
  end

  def update
    resource.assign_attributes params.fetch("diversities_#{current_step}", {}).permit!
    if resource.save
      redirect_to next_page
    else
      render action: :show
    end
  end

  def show
    diversity_session.destroy if current_step == 'confirmation'
  end

  private

  def next_page
    if params[:return_to_review].present?
      diversity_review_path
    else
      diversity_path_for page_manager.forward
    end
  end

  def diversity_path_for(page, options = {})
    send "diversity_#{page}_path".underscore, options
  end

  def page_manager
    @page_manager ||= DiversityPagesManager.new(resource: resource)
  end

  def resource
    @form ||= Form.for("diversities_/#{current_step}").new(diversity_session)
  end

  def current_step
    params[:page].underscore
  end

  def diversity
    @diversity ||= load_diversity_from_session
  end

  def diversity_session
    @diversity_session ||= load_diversity_session_from_session
  end

  def load_diversity_session_from_session
    if session[:diversity_session_id].present?
      Session.find_by(id: session[:diversity_session_id])
    end
  end

  def load_diversity_from_session
    return nil if session[:diversity_id].blank?
    Diversity.find_by(id: session[:diversity_id])
  end

  def at_the_start?
    params[:action] == 'new'
  end

  def validate_session
    if diversity_session.nil? || expired_session?
      redirect_to({ action: :new }, flash: { alert: t('diversities.show.session_reloaded') })
    end
  end

  helper_method :diversity_path_for, :diversity, :current_step,
    :page_manager, :resource
end
