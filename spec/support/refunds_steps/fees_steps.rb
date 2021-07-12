def then_all_fee_payment_method_fields_in_the_fees_page_should_be_marked_with_an_error
  expect(refund_fees_page.original_claim_fees.et_issue.payment_method_question.error.text).to eql 'Please select a payment method'
  expect(refund_fees_page.original_claim_fees.et_hearing.payment_method_question.error.text).to eql 'Please select a payment method'
  expect(refund_fees_page.original_claim_fees.et_reconsideration.payment_method_question.error.text).to eql 'Please select a payment method'
  expect(refund_fees_page.original_claim_fees.eat_issue.payment_method_question.error.text).to eql 'Please select a payment method'
  expect(refund_fees_page.original_claim_fees.eat_hearing.payment_method_question.error.text).to eql 'Please select a payment method'
end

def then_all_fee_payment_date_fields_in_the_fees_page_should_be_marked_with_an_error_for_blank_input
  expect(refund_fees_page.original_claim_fees.et_issue.payment_date_question.error.text).to eql 'Please enter the payment year and month or tick \'Don\'t know\''
  expect(refund_fees_page.original_claim_fees.et_hearing.payment_date_question.error.text).to eql 'Please enter the payment year and month or tick \'Don\'t know\''
  expect(refund_fees_page.original_claim_fees.et_reconsideration.payment_date_question.error.text).to eql 'Please enter the payment year and month or tick \'Don\'t know\''
  expect(refund_fees_page.original_claim_fees.eat_issue.payment_date_question.error.text).to eql 'Please enter the payment year and month or tick \'Don\'t know\''
  expect(refund_fees_page.original_claim_fees.eat_hearing.payment_date_question.error.text).to eql 'Please enter the payment year and month or tick \'Don\'t know\''
end

def then_all_fee_payment_date_fields_in_the_fees_page_should_be_marked_with_an_error_for_out_of_range
  expect(refund_fees_page.original_claim_fees.et_issue.payment_date_question.error.text).to eql 'The payment date must be between July 2013 and August 2017'
  expect(refund_fees_page.original_claim_fees.et_hearing.payment_date_question.error.text).to eql 'The payment date must be between July 2013 and August 2017'
  expect(refund_fees_page.original_claim_fees.et_reconsideration.payment_date_question.error.text).to eql 'The payment date must be between July 2013 and August 2017'
  expect(refund_fees_page.original_claim_fees.eat_issue.payment_date_question.error.text).to eql 'The payment date must be between July 2013 and August 2017'
  expect(refund_fees_page.original_claim_fees.eat_hearing.payment_date_question.error.text).to eql 'The payment date must be between July 2013 and August 2017'
end

def then_all_fee_payment_date_fields_in_the_fees_page_should_not_be_marked_with_an_error
  expect(refund_fees_page.original_claim_fees.et_issue.payment_date_question).to have_no_error, 'ET issue payment date should not have an error'
  expect(refund_fees_page.original_claim_fees.et_hearing.payment_date_question).to have_no_error, 'ET hearing payment date should not have an error'
  expect(refund_fees_page.original_claim_fees.et_reconsideration.payment_date_question).to have_no_error, 'ET reconsideration payment date should not have an error'
  expect(refund_fees_page.original_claim_fees.eat_issue.payment_date_question).to have_no_error, 'EAT issue payment date should not have an error'
  expect(refund_fees_page.original_claim_fees.eat_hearing.payment_date_question).to have_no_error, 'EAT refund payment date should not have an error'
end

def then_all_fee_value_fields_in_the_fees_page_should_be_marked_with_an_error_for_negative_values
  expect(refund_fees_page.original_claim_fees.et_issue.fee_question.error.text).to eql 'Fee must be greater than 0'
  expect(refund_fees_page.original_claim_fees.et_hearing.fee_question.error.text).to eql 'Fee must be greater than 0'
  expect(refund_fees_page.original_claim_fees.et_reconsideration.fee_question.error.text).to eql 'Fee must be greater than 0'
  expect(refund_fees_page.original_claim_fees.eat_issue.fee_question.error.text).to eql 'Fee must be greater than 0'
  expect(refund_fees_page.original_claim_fees.eat_hearing.fee_question.error.text).to eql 'Fee must be greater than 0'
end

def and_i_fill_in_my_refund_fees_and_verify_the_total
  test_user_fees = test_user.et_claim_to_refund.fees
  refund_fees_page.original_claim_fees.et_issue do |section|
    section.fee_question.set(test_user_fees.et_issue_fee) unless test_user_fees.et_issue_fee.nil?
    section.payment_method_question.set(test_user_fees.et_issue_payment_method) unless test_user_fees.et_issue_payment_method.nil?
    section.payment_date_question.set(test_user_fees.et_issue_payment_date) unless test_user_fees.et_issue_payment_date.nil?
    section.payment_date_unknown_question.set(test_user_fees.et_issue_payment_date_unknown) unless test_user_fees.et_issue_payment_date_unknown.nil?
  end
  refund_fees_page.original_claim_fees.et_hearing do |section|
    section.fee_question.set(test_user_fees.et_hearing_fee) unless test_user_fees.et_hearing_fee.nil?
    section.payment_method_question.set(test_user_fees.et_hearing_payment_method) unless test_user_fees.et_hearing_payment_method.nil?
    section.payment_date_question.set(test_user_fees.et_hearing_payment_date) unless test_user_fees.et_hearing_payment_date.nil?
    section.payment_date_unknown_question.set(test_user_fees.et_hearing_payment_date_unknown) unless test_user_fees.et_hearing_payment_date_unknown.nil?
  end
  refund_fees_page.original_claim_fees.et_reconsideration do |section|
    section.fee_question.set(test_user_fees.et_reconsideration_fee) unless test_user_fees.et_reconsideration_fee.nil?
    section.payment_method_question.set(test_user_fees.et_reconsideration_payment_method) unless test_user_fees.et_reconsideration_payment_method.nil?
    section.payment_date_question.set(test_user_fees.et_reconsideration_payment_date) unless test_user_fees.et_reconsideration_payment_date.nil?
    section.payment_date_unknown_question.set(test_user_fees.et_reconsideration_payment_date_unknown) unless test_user_fees.et_reconsideration_payment_date_unknown.nil?
  end
  refund_fees_page.original_claim_fees.eat_issue do |section|
    section.fee_question.set(test_user_fees.eat_issue_fee) unless test_user_fees.eat_issue_fee.nil?
    section.payment_method_question.set(test_user_fees.eat_issue_payment_method) unless test_user_fees.eat_issue_payment_method.nil?
    section.payment_date_question.set(test_user_fees.eat_issue_payment_date) unless test_user_fees.eat_issue_payment_date.nil?
    section.payment_date_unknown_question.set(test_user_fees.eat_issue_payment_date_unknown) unless test_user_fees.eat_issue_payment_date_unknown.nil?
  end
  refund_fees_page.original_claim_fees.eat_hearing do |section|
    section.fee_question.set(test_user_fees.eat_hearing_fee) unless test_user_fees.eat_hearing_fee.nil?
    section.payment_method_question.set(test_user_fees.eat_hearing_payment_method) unless test_user_fees.eat_hearing_payment_method.nil?
    section.payment_date_question.set(test_user_fees.eat_hearing_payment_date) unless test_user_fees.eat_hearing_payment_date.nil?
    section.payment_date_unknown_question.set(test_user_fees.eat_hearing_payment_date_unknown) unless test_user_fees.eat_hearing_payment_date_unknown.nil?
  end
  expected_total = [:et_issue, :et_hearing, :et_reconsideration, :eat_issue, :eat_hearing].reduce(0.0) do |t, fee|
    fee_value = test_user_fees.send("#{fee}_fee".to_sym)
    next t if fee_value.nil?
    t + fee_value.to_f
  end
  total_value = refund_fees_page.original_claim_fees.total.fee.text.gsub(/£/, '').to_f
  expect(total_value).to eql expected_total

  refund_fees_page.save_and_continue.click
end

def and_i_fill_in_all_my_refund_fee_values_only
  refund_fees_page.original_claim_fees.et_issue.fee_question.set(1)
  refund_fees_page.original_claim_fees.et_hearing.fee_question.set(1)
  refund_fees_page.original_claim_fees.et_reconsideration.fee_question.set(1)
  refund_fees_page.original_claim_fees.eat_issue.fee_question.set(1)
  refund_fees_page.original_claim_fees.eat_hearing.fee_question.set(1)
end

def and_the_fee_fields_in_the_fees_page_should_not_be_marked_with_any_errors
  aggregate_failures do
    expect(refund_fees_page.original_claim_fees.et_issue.payment_method_question).to have_no_error, 'Expected et issue payment method not to have an error'
    expect(refund_fees_page.original_claim_fees.et_hearing.payment_method_question).to have_no_error, 'Expected et hearing payment method not to have an error'
    expect(refund_fees_page.original_claim_fees.et_reconsideration.payment_method_question).to have_no_error, 'Expected et reconsideration payment method not to have an error'
    expect(refund_fees_page.original_claim_fees.eat_issue.payment_method_question).to have_no_error, 'Expected eat issue payment method not to have an error'
    expect(refund_fees_page.original_claim_fees.eat_hearing.payment_method_question).to have_no_error, 'Expected eat hearing payment method not to have an error'
    expect(refund_fees_page.original_claim_fees.et_issue.fee_question).to have_no_error, 'Expected et issue fee not to have an error'
    expect(refund_fees_page.original_claim_fees.et_hearing.fee_question).to have_no_error, 'Expected et hearing fee not to have an error'
    expect(refund_fees_page.original_claim_fees.et_reconsideration.fee_question).to have_no_error, 'Expected et reconsideration fee not to have an error'
    expect(refund_fees_page.original_claim_fees.eat_issue.fee_question).to have_no_error, 'Expected eat issue fee not to have an error'
    expect(refund_fees_page.original_claim_fees.eat_hearing.fee_question).to have_no_error, 'Expected eat hearing fee not to have an error'
  end
end

def and_i_save_the_refund_fees
  refund_fees_page.save_and_continue.click
end

def and_i_check_all_my_refund_fee_unknown_dates
  refund_fees_page.original_claim_fees.et_issue.payment_date_unknown_question.set(true)
  refund_fees_page.original_claim_fees.et_hearing.payment_date_unknown_question.set(true)
  refund_fees_page.original_claim_fees.et_reconsideration.payment_date_unknown_question.set(true)
  refund_fees_page.original_claim_fees.eat_issue.payment_date_unknown_question.set(true)
  refund_fees_page.original_claim_fees.eat_hearing.payment_date_unknown_question.set(true)
end

def and_i_fill_in_all_my_refund_fee_payment_methods_with(arg)
  fees = refund_fees_page.original_claim_fees
  fees.et_issue.payment_method_question.set(arg)
  fees.et_hearing.payment_method_question.set(arg)
  fees.et_reconsideration.payment_method_question.set(arg)
  fees.eat_issue.payment_method_question.set(arg)
  fees.eat_hearing.payment_method_question.set(arg)
end

def then_all_fee_payment_date_fields_in_the_fees_page_should_be_disabled
  expect(refund_fees_page.original_claim_fees.et_issue.payment_date_question).to be_disabled
  expect(refund_fees_page.original_claim_fees.et_issue.payment_date_unknown_question).to be_disabled
  expect(refund_fees_page.original_claim_fees.et_hearing.payment_date_question).to be_disabled
  expect(refund_fees_page.original_claim_fees.et_hearing.payment_date_unknown_question).to be_disabled
  expect(refund_fees_page.original_claim_fees.et_reconsideration.payment_date_question).to be_disabled
  expect(refund_fees_page.original_claim_fees.et_reconsideration.payment_date_unknown_question).to be_disabled
  expect(refund_fees_page.original_claim_fees.eat_issue.payment_date_question).to be_disabled
  expect(refund_fees_page.original_claim_fees.eat_issue.payment_date_unknown_question).to be_disabled
  expect(refund_fees_page.original_claim_fees.eat_hearing.payment_date_question).to be_disabled
  expect(refund_fees_page.original_claim_fees.eat_hearing.payment_date_unknown_question).to be_disabled
end

def and_all_fee_payment_method_fields_in_the_fees_page_should_be_disabled
  expect(refund_fees_page.original_claim_fees.et_issue.payment_method_question).to be_disabled
  expect(refund_fees_page.original_claim_fees.et_hearing.payment_method_question).to be_disabled
  expect(refund_fees_page.original_claim_fees.et_reconsideration.payment_method_question).to be_disabled
  expect(refund_fees_page.original_claim_fees.eat_issue.payment_method_question).to be_disabled
  expect(refund_fees_page.original_claim_fees.eat_hearing.payment_method_question).to be_disabled
end

def and_i_fill_in_all_my_refund_fee_dates_with(date)
  fees = refund_fees_page.original_claim_fees
  fees.et_issue.payment_date_question.set(date)
  fees.et_hearing.payment_date_question.set(date)
  fees.et_reconsideration.payment_date_question.set(date)
  fees.eat_issue.payment_date_question.set(date)
  fees.eat_hearing.payment_date_question.set(date)
end

def then_the_refund_fees_form_should_show_an_error_stating_that_at_least_one_fee_should_be_present
  expect(refund_fees_page.form_error_message).to have_text('You must enter a fee in the relevant field')
end

def and_i_fill_in_the_refund_fee_values_with_negative_values
  original_claim_fees = refund_fees_page.original_claim_fees
  [:et_issue, :et_hearing, :et_reconsideration, :eat_issue, :eat_hearing].each do |fee|
    original_claim_fees.send(fee).fee_question.set('-1')
  end
end
