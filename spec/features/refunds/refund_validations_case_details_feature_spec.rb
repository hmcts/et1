require 'rails_helper'

RSpec.feature 'Refund Validations - Case Details Page', js: true do
  #In order to ensure that the information provided to the business is
  #as accurate as possible, field level validation is required to show
  #the user where they have gone wrong before they move on to the next step

  before do
    given_i_am_luke_skywalker
    and_i_want_a_refund_for_my_previous_et_claim_with_case_number_1234567_2016
    and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_i_did_not_have_a_representative
    when_i_start_a_new_refund_for_a_sole_party_who_paid_the_tribunal_fees_directly_and_has_not_been_reimbursed
    and_i_fill_in_my_refund_applicant_details
  end

  scenario 'A user does not fill in any fields in the case details step' do
    and_i_save_the_refund_case_details
    and_all_mandatory_respondent_address_fields_in_the_refund_case_details_should_be_marked_with_an_error
    and_the_country_of_claim_field_in_the_refunds_case_details_should_be_marked_with_an_error
    and_the_has_your_address_changed_field_in_the_refund_case_details_should_be_marked_with_an_error
    and_the_had_representative_field_in_the_refund_case_details_should_be_marked_with_an_error
  end

  scenario 'A user does not fill in any fields in the case details step with same address' do
    when_i_answer_no_to_the_has_your_address_changed_question_for_refunds
    and_i_save_the_refund_case_details
    and_all_mandatory_respondent_address_fields_in_the_refund_case_details_should_be_marked_with_an_error
    and_the_had_representative_field_in_the_refunds_case_details_should_be_marked_with_an_error
    and_the_country_of_claim_field_in_the_refunds_case_details_should_be_marked_with_an_error
  end

  scenario 'A user does not fill in any fields in the case details step with changed address' do
    when_i_answer_yes_to_the_has_your_address_changed_question_for_refunds
    and_i_save_the_refund_case_details
    then_all_mandatory_claimant_address_fields_in_the_refund_case_details_should_be_marked_with_an_error
    and_all_mandatory_respondent_address_fields_in_the_refund_case_details_should_be_marked_with_an_error
    and_the_had_representative_field_in_the_refunds_case_details_should_be_marked_with_an_error
  end

  scenario 'A user does not fill in any fields apart from has representative in the case details step with same address' do
    when_i_answer_no_to_the_has_your_address_changed_question_for_refunds
    and_i_answer_yes_to_the_had_representative_question_for_refunds
    and_i_save_the_refund_case_details
    and_all_mandatory_respondent_address_fields_in_the_refund_case_details_should_be_marked_with_an_error
    and_all_mandatory_representative_address_fields_in_the_refund_case_details_should_be_marked_with_an_error
    and_all_mandatory_case_details_fields_in_the_refund_case_details_should_be_marked_with_an_error
  end

  scenario 'A user fills in wrongly formatted ET and ET case numbers in the case details step with same address and no representative' do
    when_i_answer_no_to_the_has_your_address_changed_question_for_refunds
    and_i_answer_no_to_the_had_representative_question_for_refunds
    then_i_fill_in_my_refund_original_case_details_with \
      [
       {field: 'et_case_number', value: '12345678/2019'},
       {field: 'eat_case_number', value: 'UKWRONG/1234/16/001'}

      ]
    and_i_save_the_refund_case_details
    then_i_should_see_the_following_errors_in_the_case_details_section_of_the_refund_case_details_step \
      [
        {field: 'et_case_number', error: 'Must be in the format nnnnnnn/nnnn'},
        {field: 'eat_case_number', error: 'Must be in the format UKEAT/nnnn/nn/nnn'}
      ]
  end

  scenario 'A user types too many characters into the additional information field in the case details step with same address and no representative' do
    when_i_answer_no_to_the_has_your_address_changed_question_for_refunds
    and_i_answer_no_to_the_had_representative_question_for_refunds
    and_i_enter_501_characters_into_the_additional_information_field_in_the_refund_case_details
    then_i_should_see_too_many_chars_message_in_the_additional_information_field_in_the_refund_case_details
  end
end
