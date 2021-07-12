require 'rails_helper'
RSpec.feature 'Refund Validations - Fees Page', js: true do
  #In order to ensure that the information provided to the business is
  #as accurate as possible, field level validation is required to show
  #the user where they have gone wrong before they move on to the next step

  before do
    given_i_am_luke_skywalker
    and_i_want_a_refund_for_my_previous_et_claim_with_case_number_1234567_2016
    and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_my_address_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_i_did_not_have_a_representative
    when_i_start_a_new_refund_for_a_sole_party_who_paid_the_tribunal_fees_directly_and_has_not_been_reimbursed
    and_i_fill_in_my_refund_applicant_details
    and_i_fill_in_my_refund_original_case_details
  end

  scenario 'A user fills in fees but no payment method or date' do
    and_i_fill_in_all_my_refund_fee_values_only
    and_i_save_the_refund_fees
    then_all_fee_payment_method_fields_in_the_fees_page_should_be_marked_with_an_error
    then_all_fee_payment_date_fields_in_the_fees_page_should_be_marked_with_an_error_for_blank_input
  end

  scenario 'A user fills in negative fees' do
    and_i_fill_in_the_refund_fee_values_with_negative_values
    and_i_save_the_refund_fees
    then_all_fee_value_fields_in_the_fees_page_should_be_marked_with_an_error_for_negative_values
  end

  scenario 'A user fills in no fees data at all and submits' do
    and_i_save_the_refund_fees
    then_the_refund_fees_form_should_show_an_error_stating_that_at_least_one_fee_should_be_present
  end

  scenario 'A user fills in no fees data at all and does not submit' do
    then_all_fee_payment_date_fields_in_the_fees_page_should_be_disabled
    and_all_fee_payment_method_fields_in_the_fees_page_should_be_disabled
  end
  scenario 'A user fills in fees but no payment method and an unknown date' do
    and_i_fill_in_all_my_refund_fee_values_only
    and_i_check_all_my_refund_fee_unknown_dates
    and_i_save_the_refund_fees
    then_all_fee_payment_method_fields_in_the_fees_page_should_be_marked_with_an_error
    then_all_fee_payment_date_fields_in_the_fees_page_should_not_be_marked_with_an_error
  end
  scenario 'A user fills in fees but the "Don\'t know" payment method and an unknown date' do
    and_i_fill_in_all_my_refund_fee_values_only
    and_i_check_all_my_refund_fee_unknown_dates
    and_i_fill_in_all_my_refund_fee_payment_methods_with "Don't know"
    and_i_save_the_refund_fees
    then_i_should_see_the_refund_bank_details_page
  end
end
