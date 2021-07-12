def when_i_answer_yes_to_the_has_your_name_changed_question_for_refunds
  refund_applicant_page.has_name_changed_question.set('Yes')
end
def when_i_answer_no_to_the_has_your_name_changed_question_for_refunds
  refund_applicant_page.has_name_changed_question.set('No')
end

def and_i_fill_in_my_refund_claimant_details_with(table_hashes)
  # table is a table.hashes.keys # => [:field, :value]
  table_hashes.each do |hash|
    refund_applicant_page.about_the_claimant do |section|
      node = section.send("#{hash[:field]}_question".to_sym)
      node.set(hash[:value])
    end
  end

end

def and_i_fill_in_my_refund_claimant_contact_details_with(table_hashes)
  # table is a table.hashes.keys # => [:field, :value]
  table_hashes.each do |hash|
    refund_applicant_page.claimants_contact_details do |section|
      node = section.send("#{hash[:field]}_question".to_sym)
      node.set(hash[:value])
    end
  end
end

def and_i_save_the_refund_applicant_details
  refund_applicant_page.save_and_continue.click
end

def then_the_user_should_be_informed_that_there_are_errors_on_the_refund_applicant_page
  expect(refund_applicant_page.form_error_message).to be_visible
end

def and_all_mandatory_fields_in_the_refund_applicant_page_should_be_marked_with_an_error
  aggregate_failures do
    expect(refund_applicant_page.about_the_claimant.title_question.error.text).to eql "Select a title from the list"
    expect(refund_applicant_page.about_the_claimant.first_name_question.error.text).to eql "Enter your first name"
    expect(refund_applicant_page.about_the_claimant.last_name_question.error.text).to eql "Enter your last name"
    expect(refund_applicant_page.about_the_claimant.date_of_birth_question.error.text).to eql "Enter your date of birth"
    expect(refund_applicant_page.claimants_contact_details.building_question.error.text).to eql "Enter the building number or name from your address"
    expect(refund_applicant_page.claimants_contact_details.street_question.error.text).to eql "Enter the street from your address"
    expect(refund_applicant_page.claimants_contact_details.locality_question.error.text).to eql "Enter the town or city from the claimant’s address"
    expect(refund_applicant_page.claimants_contact_details.post_code_question.error.text).to eql "Enter your post code"
    expect(refund_applicant_page.claimants_contact_details.telephone_number_question.error.text).to eql "Enter your preferred number"

    expect(refund_applicant_page.claimants_contact_details.county_question).to have_no_error, 'Expected county not to have an error'
    expect(refund_applicant_page.claimants_contact_details.email_address_question).to have_no_error, 'Expected email address not to have an error'
  end
end

def and_i_fill_in_my_refund_applicant_details
  refund_applicant_page.has_name_changed_question.set(test_user.has_name_changed) unless test_user.has_name_changed.nil?
  refund_applicant_page.about_the_claimant do |section|
    section.title_question.set(test_user.title)
    section.first_name_question.set(test_user.first_name)
    section.last_name_question.set(test_user.last_name)
    section.date_of_birth_question.set(test_user.date_of_birth)
  end
  refund_applicant_page.claimants_contact_details do |section|
    section.building_question.set(test_user.address.building) unless test_user.address.building.nil?
    section.street_question.set(test_user.address.street) unless test_user.address.street.nil?
    section.locality_question.set(test_user.address.locality) unless test_user.address.locality.nil?
    section.county_question.set(test_user.address.county) unless test_user.address.county.nil?
    section.post_code_question.set(test_user.address.post_code) unless test_user.address.post_code.nil?
    section.telephone_number_question.set(test_user.telephone_number) unless test_user.telephone_number.nil?
    section.email_address_question.set(test_user.email_address) unless test_user.email_address.nil?
  end
  and_i_save_the_refund_applicant_details
end

def then_the_continue_button_should_be_disabled_on_the_refund_applicant_page
  expect(refund_applicant_page.save_and_continue).to be_disabled
end

def and_the_email_address_in_the_refund_applicant_page_should_be_marked_with_an_invalid_error
  expect(refund_applicant_page.claimants_contact_details.email_address_question.error.text).to eql 'is invalid'
end

def and_the_date_of_birth_in_the_refund_applicant_page_should_be_marked_with_an_invalid_error
  expect(refund_applicant_page.about_the_claimant.date_of_birth_question.error.text).to eql 'is invalid'
end

def then_the_title_field_in_the_applicant_page_should_have_the_correct_default_option_selected
  expect(refund_applicant_page.about_the_claimant.title_question.value).to eql 'Please select'
end
