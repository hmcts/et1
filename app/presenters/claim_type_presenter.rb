class ClaimTypePresenter < Presenter
  def subsections
    { type: %i<types is_whistleblowing send_claim_to_whistleblowing_entity> }
  end

  def types
    claims = []

    if is_unfair_dismissal
      claims << I18n.t("simple_form.labels.claim_type.is_unfair_dismissal")
    end

    claims.push *target.pay_claims.
      map { |c| I18n.t "simple_form.options.claim_type.pay_claims.#{c}" }

    claims.push *target.discrimination_claims.
      map { |c| I18n.t "simple_form.options.claim_type.discrimination_claims.#{c}" }

    claims.join('<br />').html_safe
  end

  def is_whistleblowing
    yes_no target.is_whistleblowing
  end

  def send_claim_to_whistleblowing_entity
    yes_no target.send_claim_to_whistleblowing_entity
  end
end
