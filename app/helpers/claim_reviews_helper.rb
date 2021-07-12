module ClaimReviewsHelper
  def incomplete_claim_warning(claim)
    unless claim.submittable?
      render partial: 'error_header', locals: {
        summary: t('.incomplete_claim_summary'),
        message: t('.incomplete_claim_message')
      }
    end
  end

  def claim_presenter
    @claim_presenter ||= ClaimPresenter.new(claim)
  end

  def confirmation_email(claim)
    @confirmation_email ||= ConfirmationEmail.new(claim)
  end

  def quick_edit_link_for(section)
    link_to t('.edit'), claim_path_for(section, return_to_review: true), class: 'govuk-link'
  end

  def submit_button_text(claim)
    t '.submit'
  end

  def review_date(date)
    return date if date.nil?
    I18n.l date, format: '%d %B %Y'
  end

  def review_pay_for(pay, period)
    if [pay, period].all?(&:present?)
      number_to_currency(pay) + ' ' + t("claim_reviews.item.employment.pay_period_#{period}")
    end
  end

  def review_types(claim)
    claims = []

    if claim.is_unfair_dismissal?
      claims << I18n.t("simple_form.labels.claim.is_unfair_dismissal")
    end

    claims.push(*claim.pay_claims.map { |c| I18n.t "claims.claim_type.pay_claims.options.#{c}" })

    claims.push(*claim.discrimination_claims.map { |c| I18n.t "simple_form.options.claim_type.discrimination_claims_for_review.#{c}" })

    claims.join(tag(:br)).html_safe
  end

  def review_claimant_full_name(claimant)
    salutation = t("claims.personal_details.title.options.#{claimant.title}") unless claimant.title.nil?
    [salutation, claimant.first_name, claimant.last_name].compact.join' '
  end



end
