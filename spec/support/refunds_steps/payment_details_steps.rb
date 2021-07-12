def and_i_fill_in_my_refund_bank_details_with(table_hashes)
  table_hashes.each do |hash|
    refund_payment_details_page.bank_details do |section|
      node = section.send("#{hash[:field]}_question".to_sym)
      node.set(hash[:value])
    end
  end
end

def and_i_fill_in_my_refund_building_society_details_with(table_hashes)
  table_hashes.each do |hash|
    refund_payment_details_page.building_society_details do |section|
      node = section.send("#{hash[:field]}_question".to_sym)
      node.set(hash[:value])
    end
  end
end

def and_i_save_the_refund_bank_details
  refund_payment_details_page.save_and_continue.click
end

def and_i_fill_in_my_refund_bank_details
  if test_user.bank_account.present?
    refund_payment_details_page.account_type_question.set('Bank')
    refund_payment_details_page.bank_details do |section|
      section.account_name_question.set(test_user.bank_account.account_name)
      section.bank_name_question.set(test_user.bank_account.bank_name)
      section.account_number_question.set(test_user.bank_account.account_number)
      section.sort_code_question.set(test_user.bank_account.sort_code)
    end
  elsif test_user.building_society_account.present?
    refund_payment_details_page.account_type_question.set('Building Society')
    refund_payment_details_page.building_society_details do |section|
      section.account_name_question.set(test_user.building_society_account.account_name)
      section.building_society_name_question.set(test_user.building_society_account.building_society_name)
      section.account_number_question.set(test_user.building_society_account.account_number)
      section.sort_code_question.set(test_user.building_society_account.sort_code)
    end
  else
    raise "No bank or building society details present in the test_user"
  end

  refund_payment_details_page.save_and_continue.click

end

def then_i_should_see_the_refund_bank_details_page
  expect(refund_payment_details_page).to be_displayed
end

def then_all_mandatory_bank_details_fields_should_be_marked_with_an_error
  aggregate_failures do
    expect(refund_payment_details_page.bank_details.account_name_question.error.text).to eql "Enter Account holder name"
    expect(refund_payment_details_page.bank_details.bank_name_question.error.text).to eql "Enter Bank name"
    expect(refund_payment_details_page.bank_details.account_number_question.error.text).to eql "Enter Bank account"
    expect(refund_payment_details_page.bank_details.sort_code_question.error.text).to eql "Enter Sort Code"
    expect(refund_payment_details_page).to have_no_building_society_details
  end
end

def then_all_mandatory_building_society_details_fields_should_be_marked_with_an_error
  aggregate_failures do
    expect(refund_payment_details_page.building_society_details.account_name_question.error.text).to eql "Enter the name on the building society account"
    expect(refund_payment_details_page.building_society_details.building_society_name_question.error.text).to eql "Enter the name of the building society"
    expect(refund_payment_details_page.building_society_details.account_number_question.error.text).to eql "Enter the account number that the refund is to be paid into"
    expect(refund_payment_details_page.building_society_details.sort_code_question.error.text).to eql "Enter the sort code of the account that the refund is to be paid into"
    expect(refund_payment_details_page).to have_no_bank_details
  end
end

def and_i_select_bank_account_type_in_the_refund_bank_details_page
  refund_payment_details_page.account_type_question.set('Bank')
end

def and_i_select_building_society_account_type_in_the_refund_bank_details_page
  refund_payment_details_page.account_type_question.set('Building Society')
end

def then_only_the_bank_details_account_type_field_should_be_marked_with_an_error
  expect(refund_payment_details_page.account_type_question.error.text).to eql "Please select one of the options"
  expect(refund_payment_details_page.bank_details.account_name_question).to have_no_error
  expect(refund_payment_details_page.bank_details.bank_name_question).to have_no_error
  expect(refund_payment_details_page.bank_details.account_number_question).to have_no_error
  expect(refund_payment_details_page.bank_details.sort_code_question).to have_no_error
  expect(refund_payment_details_page.building_society_details.account_name_question).to have_no_error
  expect(refund_payment_details_page.building_society_details.building_society_name_question).to have_no_error
  expect(refund_payment_details_page.building_society_details.account_number_question).to have_no_error
  expect(refund_payment_details_page.building_society_details.sort_code_question).to have_no_error
end

def then_the_continue_button_should_be_disabled_on_the_bank_details_page
  expect(refund_payment_details_page.save_and_continue).to be_disabled
end

def then_the_bank_account_number_field_should_be_marked_with_an_invalid_error_in_the_refund_bank_details_page
  expect(refund_payment_details_page.bank_details.account_number_question.error.text).to eql "Must be 8 numbers"
end

def then_the_bank_sort_code_field_should_be_marked_with_an_invalid_error_in_the_refund_bank_details_page
  expect(refund_payment_details_page.bank_details.sort_code_question.error.text).to eql "Must be 6 numbers"
end

def then_the_building_society_account_number_field_should_be_marked_with_an_invalid_error_in_the_refund_bank_details_page
  expect(refund_payment_details_page.building_society_details.account_number_question.error.text).to eql "Must be 8 numbers"
end

def then_the_building_society_sort_code_field_should_be_marked_with_an_invalid_error_in_the_refund_bank_details_page
  expect(refund_payment_details_page.building_society_details.sort_code_question.error.text).to eql "Must be 6 numbers"
end
