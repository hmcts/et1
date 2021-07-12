def then_i_fill_in_my_refund_original_case_details_with(table_hashes)
  table_hashes.each do |hash|
    refund_original_case_details_page.original_case_details do |section|
      node = section.send("#{hash[:field]}_question".to_sym)
      node.set(hash[:value])
    end
  end
end

def then_i_fill_in_my_refund_original_case_details_respondent_details_with(table_hashes)
  table_hashes.each do |hash|
    refund_original_case_details_page.original_respondent_details do |section|
      node = section.send("#{hash['field']}_question".to_sym)
      node.set(hash['value'])
    end
  end
end

def then_i_fill_in_my_refund_original_case_details_representative_details_with(table_hashes)
  table_hashes.each do |hash|
    refund_original_case_details_page.original_representative_details do |section|
      node = section.send("#{hash['field']}_question".to_sym)
      node.set(hash['value'])
    end
  end
end

def then_i_fill_in_my_refund_issue_fee_with(table_hashes)
  table_hashes.each do |hash|
    refund_original_case_details_page.original_claim_fees.et_issue do |section|
      section.fee_question.set(hash['fee'])
      section.payment_method_question.select(hash['payment method'])
    end
  end
end

def then_i_fill_in_my_refund_hearing_fee_with(table_hashes)
  table_hashes.each do |hash|
    refund_original_case_details_page.original_claim_fees.et_hearing do |section|
      section.fee_question.set(hash['fee'])
      section.payment_method_question.select(hash['payment method'])
    end
  end
end

def then_i_fill_in_my_refund_eat_issue_fee_with(table_hashes)
  table_hashes.each do |hash|
    refund_original_case_details_page.original_claim_fees.eat_issue do |section|
      section.fee_question.set(hash['fee'])
      section.payment_method_question.select(hash['payment method'])
    end
  end
end

def then_i_fill_in_my_refund_eat_hearing_fee_with(table_hashes)
  table_hashes.each do |hash|
    refund_original_case_details_page.original_claim_fees.eat_hearing do |section|
      section.fee_question.set(hash['fee'])
      section.payment_method_question.select(hash['payment method'])
    end
  end
end

def then_i_fill_in_my_refund_application_reconsideration_fee_with(table_hashes)
  table_hashes.each do |hash|
    refund_original_case_details_page.original_claim_fees.et_reconsideration do |section|
      section.fee_question.set(hash['fee'])
      section.payment_method_question.select(hash['payment method'])
    end
  end
end

def when_i_answer_yes_to_the_has_your_address_changed_question_for_refunds
  refund_original_case_details_page.address_changed_question.set('Yes')
end
def when_i_answer_no_to_the_has_your_address_changed_question_for_refunds
  refund_original_case_details_page.address_changed_question.set('No')
end

def and_i_save_the_refund_case_details
  refund_original_case_details_page.save_and_continue.click
end

def and_i_fill_in_my_refund_original_case_details
  refund_original_case_details_page.address_changed_question.set(test_user.claim_address_changed) unless test_user.claim_address_changed.nil?
  if test_user.claim_address_changed == 'Yes'
    refund_original_case_details_page.original_claimant_details do |section|
      section.building_question.set(test_user.et_claim_to_refund.address.building) unless test_user.et_claim_to_refund.address.building.nil?
      section.street_question.set(test_user.et_claim_to_refund.address.street) unless test_user.et_claim_to_refund.address.street.nil?
      section.locality_question.set(test_user.et_claim_to_refund.address.locality) unless test_user.et_claim_to_refund.address.locality.nil?
      section.county_question.set(test_user.et_claim_to_refund.address.county) unless test_user.et_claim_to_refund.address.county.nil?
      section.post_code_question.set(test_user.et_claim_to_refund.address.post_code) unless test_user.et_claim_to_refund.address.post_code.nil?
    end
  end
  refund_original_case_details_page.original_case_details do |section|
    section.et_country_of_claim_question.set(test_user.et_claim_to_refund.et_country_of_claim) unless test_user.et_claim_to_refund.et_country_of_claim.nil?
    section.et_case_number_question.set(test_user.et_claim_to_refund.et_case_number) unless test_user.et_claim_to_refund.et_case_number.nil?
    section.eat_case_number_question.set(test_user.et_claim_to_refund.eat_case_number) unless test_user.et_claim_to_refund.eat_case_number.nil?
    section.et_tribunal_office_question.set(test_user.et_claim_to_refund.et_tribunal_office) unless test_user.et_claim_to_refund.et_tribunal_office.nil?
    section.additional_information_question.set(test_user.et_claim_to_refund.additional_information) unless test_user.et_claim_to_refund.additional_information.nil?
  end

  refund_original_case_details_page.original_respondent_details do |section|
    section.name_question.set(test_user.et_claim_to_refund.respondent.name) unless test_user.et_claim_to_refund.respondent.name.nil?
    section.building_question.set(test_user.et_claim_to_refund.respondent.address.building) unless test_user.et_claim_to_refund.respondent.address.building.nil?
    section.street_question.set(test_user.et_claim_to_refund.respondent.address.street) unless test_user.et_claim_to_refund.respondent.address.street.nil?
    section.locality_question.set(test_user.et_claim_to_refund.respondent.address.locality) unless test_user.et_claim_to_refund.respondent.address.locality.nil?
    section.county_question.set(test_user.et_claim_to_refund.respondent.address.county) unless test_user.et_claim_to_refund.respondent.address.county.nil?
    section.post_code_question.set(test_user.et_claim_to_refund.respondent.address.post_code) unless test_user.et_claim_to_refund.respondent.address.post_code.nil?
  end


  refund_original_case_details_page.claim_had_representative_question.set(test_user.et_claim_to_refund.has_representative) unless test_user.et_claim_to_refund.has_representative.nil?
  if test_user.et_claim_to_refund.has_representative == 'Yes'
    refund_original_case_details_page.original_representative_details do |section|
      section.name_question.set(test_user.et_claim_to_refund.representative.name) unless test_user.et_claim_to_refund.representative.name.nil?
      section.building_question.set(test_user.et_claim_to_refund.representative.address.building) unless test_user.et_claim_to_refund.representative.address.building.nil?
      section.street_question.set(test_user.et_claim_to_refund.representative.address.street) unless test_user.et_claim_to_refund.representative.address.street.nil?
      section.locality_question.set(test_user.et_claim_to_refund.representative.address.locality) unless test_user.et_claim_to_refund.representative.address.locality.nil?
      section.county_question.set(test_user.et_claim_to_refund.representative.address.county) unless test_user.et_claim_to_refund.representative.address.county.nil?
      section.post_code_question.set(test_user.et_claim_to_refund.representative.address.post_code) unless test_user.et_claim_to_refund.representative.address.post_code.nil?
    end
  end

  refund_original_case_details_page.save_and_continue.click

end

def then_all_mandatory_claimant_address_fields_in_the_refund_case_details_should_be_marked_with_an_error
  aggregate_failures do
    expect(refund_original_case_details_page.original_claimant_details.building_question.error.text).to eql "Enter the building number or name from your address at the time of the original claim"
    expect(refund_original_case_details_page.original_claimant_details.street_question.error.text).to eql "Enter the street from your address at the time of the original claim"
    expect(refund_original_case_details_page.original_claimant_details.post_code_question.error.text).to eql "Enter your post code at the time of the original claim"
    expect(refund_original_case_details_page.original_claimant_details.locality_question).to have_no_error, 'Expected claimant locality not to have an error'
    expect(refund_original_case_details_page.original_claimant_details.county_question).to have_no_error, 'Expected claimant county not to have an error'
  end
end

def and_all_mandatory_respondent_address_fields_in_the_refund_case_details_should_be_marked_with_an_error
  aggregate_failures do
    expect(refund_original_case_details_page.original_respondent_details.name_question.error.text).to eql "Enter the respondent's name"
    expect(refund_original_case_details_page.original_respondent_details.building_question.error.text).to eql "Enter the building number or name from the respondent's address"
    expect(refund_original_case_details_page.original_respondent_details.street_question.error.text).to eql "Enter the street from the respondent's address"
    expect(refund_original_case_details_page.original_respondent_details.locality_question).to have_no_error, 'Expected respondent locality not to have an error'
    expect(refund_original_case_details_page.original_respondent_details.post_code_question).to have_no_error, 'Expected respondent post code not to have an error'
    expect(refund_original_case_details_page.original_respondent_details.county_question).to have_no_error, 'Expected respondent county not to have an error'
  end
end

def and_all_mandatory_representative_address_fields_in_the_refund_case_details_should_be_marked_with_an_error
  aggregate_failures do
    expect(refund_original_case_details_page.original_representative_details.name_question.error.text).to eql "Enter the representative's name"
    expect(refund_original_case_details_page.original_representative_details.building_question.error.text).to eql "Enter the building number or name from the representative's address"
    expect(refund_original_case_details_page.original_representative_details.street_question.error.text).to eql "Enter the street from the representative's address"
    expect(refund_original_case_details_page.original_representative_details.post_code_question.error.text).to eql "Enter the representative's post code"
    expect(refund_original_case_details_page.original_representative_details.locality_question).to have_no_error, 'Expected rep locality not to have an error'
    expect(refund_original_case_details_page.original_representative_details.county_question).to have_no_error, 'Expected rep county not to have an error'
  end
end

def and_the_had_representative_field_in_the_refunds_case_details_should_be_marked_with_an_error
  expect(refund_original_case_details_page.claim_had_representative_question.error.text).to eql "Please select Yes or No"
end

def and_the_country_of_claim_field_in_the_refunds_case_details_should_be_marked_with_an_error
  expect(refund_original_case_details_page.original_case_details.et_country_of_claim_question.error.text).to eql "Please select the country where your case was heard"
end

def and_i_answer_yes_to_the_had_representative_question_for_refunds
  refund_original_case_details_page.claim_had_representative_question.set('Yes')
end
def and_i_answer_no_to_the_had_representative_question_for_refunds
  refund_original_case_details_page.claim_had_representative_question.set('No')
end

def and_all_mandatory_case_details_fields_in_the_refund_case_details_should_be_marked_with_an_error
  aggregate_failures do
    expect(refund_original_case_details_page.original_case_details.et_country_of_claim_question.error.text).to eql "Please select the country where your case was heard"
    expect(refund_original_case_details_page.original_case_details.et_case_number_question).to have_no_error
    expect(refund_original_case_details_page.original_case_details.eat_case_number_question).to have_no_error
    expect(refund_original_case_details_page.original_case_details.et_tribunal_office_question).to have_no_error
    expect(refund_original_case_details_page.original_case_details.additional_information_question).to have_no_error
  end
end

def then_i_should_see_the_following_errors_in_the_case_details_section_of_the_refund_case_details_step(table_hashes)
  # table is a table_hashes.keys # => [:field, :error]
  table_hashes.each do |hash|
    expect(refund_original_case_details_page.original_case_details.send("#{hash[:field]}_question".to_sym).error.text).to eql hash[:error]
  end
end

def and_i_enter_501_characters_into_the_additional_information_field_in_the_refund_case_details
  str = "a" * 501
  refund_original_case_details_page.original_case_details.additional_information_question.set(str)
end

def then_i_should_see_too_many_chars_message_in_the_additional_information_field_in_the_refund_case_details
  refund_original_case_details_page.original_case_details.additional_information_question.assert_too_many_characters
end

def and_the_has_your_address_changed_field_in_the_refund_case_details_should_be_marked_with_an_error
  expect(refund_original_case_details_page.address_changed_question.error.text).to eql 'Please select Yes or No'
end

def and_the_had_representative_field_in_the_refund_case_details_should_be_marked_with_an_error
  expect(refund_original_case_details_page.claim_had_representative_question.error.text).to eql 'Please select Yes or No'
end

def then_the_where_was_your_claim_issued_field_in_the_applicant_page_should_have_the_correct_default_option_selected
  refund_original_case_details_page.original_case_details.et_country_of_claim_question.assert_value('Please select')
end

def and_the_employment_tribunal_office_field_in_the_applicant_page_should_have_the_correct_default_option_selected
  refund_original_case_details_page.original_case_details.et_tribunal_office_question.assert_value 'Please select'
end
