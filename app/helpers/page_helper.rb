module PageHelper
  def start_session_timer?
    unless_new_path = -> { action_name != 'new' }
    is_registration_page? || is_claim_page?(claims_condition: unless_new_path)
  end

  def show_signout?
    unless_new_path_or_application_form = \
      -> { action_name != 'new' && params[:page] != 'application-number' }

    is_claim_page?(claims_condition: unless_new_path_or_application_form)
  end

  def is_claim_page?(claims_condition: -> { true })
    case controller_name
    when 'claims', 'registrations' then claims_condition.call
    when *claim_pages_list then true
    else false
    end
  end

  private

  def is_registration_page?
    controller_name == 'registrations' && action_name == 'new'
  end

  def claim_pages_list
    ['claim_reviews', 'payments', 'multiple_claimants', 'multiple_respondents']
  end
end
