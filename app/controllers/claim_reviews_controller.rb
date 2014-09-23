class ClaimReviewsController < ApplicationController
  before_action :ensure_claim_in_progress

  def update
    claim.submit!
    BaseMailer.confirmation_email(claim, email_address_params).deliver_later
    redirect_to claim.payment_required? ? page_claim_path(page: 'pay') : claim_confirmation_path
  end

  private def email_address_params
    params[:confirmation_email][:email_addresses] +
      params[:confirmation_email][:additional_email_address].values
  end

  helper_method def presenter
    @presenter ||= ClaimPresenter.new(claim)
  end

  helper_method def confirmation_email
    ConfirmationEmail.new
  end

  helper_method def email_addresses
    claimants = claim.claimants.map(&:email_address)
    representatives = [claim.representative.try(:email_address)]

    (claimants + representatives).reject(&:blank?)
  end
end
