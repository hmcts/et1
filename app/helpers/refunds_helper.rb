module RefundsHelper
  delegate :current_page, :total_pages, to: :page_manager

  def format(text)
    markdown.render(text)
  end

  def refund_header
    I18n.t("refunds.#{current_step}.header")
  end

  def refund_title
    page_title(refund_header)
  end

  def country_of_claim_for(id)
    I18n.t("refunds.original_case_details.et_country_of_claim.options.#{id}")
  end

  def et_office_for(id)
    return '' if id.blank?
    I18n.t("refunds.original_case_details.et_tribunal_office.options.#{id}")
  end

  def payment_date_for(obj, fee)
    if obj.send("#{fee}_payment_date_unknown")
      I18n.t('helpers.refunds.payment_date_unknown')
    else
      obj.send("#{fee}_payment_date").strftime('%B %Y')
    end
  end

  def payment_method_for(obj, fee)
    payment_method = obj.send("#{fee}_payment_method")
    I18n.t("refunds.fees.#{fee}_payment_method.options.#{payment_method}")
  end

  private

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
