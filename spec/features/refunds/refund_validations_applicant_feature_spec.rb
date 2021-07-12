require 'rails_helper'
RSpec.feature 'Refund Validations - Applicant page', js: true do
  #In order to ensure that the information provided to the business is
  #as accurate as possible, field level validation is required to show
  #the user where they have gone wrong before they move on to the next step

  before do
    given_i_am_luke_skywalker
    and_i_want_a_refund_for_my_previous_et_claim_with_case_number_1234567_2016
    and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_i_did_not_have_a_representative
    when_i_start_a_new_refund_for_a_sole_party_who_paid_the_tribunal_fees_directly_and_has_not_been_reimbursed
  end

  scenario 'A user does not fill in any fields in the applicant step' do
    then_the_continue_button_should_be_disabled_on_the_refund_applicant_page
  end

  scenario 'A user does not fill in any fields in the applicant step after answering the name change question as no' do
    when_i_answer_no_to_the_has_your_name_changed_question_for_refunds
    and_i_save_the_refund_applicant_details
    then_the_user_should_be_informed_that_there_are_errors_on_the_refund_applicant_page
    and_all_mandatory_fields_in_the_refund_applicant_page_should_be_marked_with_an_error
  end

  scenario 'A user answers yes to the name changed question in the applicant step' do
    when_i_answer_yes_to_the_has_your_name_changed_question_for_refunds
    then_the_continue_button_should_be_disabled_on_the_refund_applicant_page
  end

  scenario 'A user answers no to name change and fills in an invalid email address and date of birth' do
    when_i_answer_no_to_the_has_your_name_changed_question_for_refunds
    and_i_fill_in_my_refund_claimant_contact_details_with \
      [
        { field: 'email_address', value: 'domain.com' }
      ]
    and_i_fill_in_my_refund_claimant_details_with \
      [
        { field: 'date_of_birth', value: 'aa/12/3020' }
      ]
    and_i_save_the_refund_applicant_details
    then_the_user_should_be_informed_that_there_are_errors_on_the_refund_applicant_page
    and_the_email_address_in_the_refund_applicant_page_should_be_marked_with_an_invalid_error
    and_the_date_of_birth_in_the_refund_applicant_page_should_be_marked_with_an_invalid_error
  end
end



