require 'rails_helper'
RSpec.describe 'Respondents Details Validation', type: :feature, js: true do
  it 'filters out an incorrect phone number and provides the correct message' do
    # Arrange - get to the page loaded with a claimant with the phone number overridden
    claimant = build(:ui_claimant, :mandatory)
    respondent = build(:ui_respondent, :mandatory, phone_number: 'wrong')

    apply_page.load
    apply_page.start_a_claim
    saving_your_claim_page.register(email_address: 'fred@bloggs.com', password: 'password')
    claimants_details_page.fill_in_all(claimant: claimant)
    claimants_details_page.save_and_continue
    group_claims_page.no_secondary_claimants
    group_claims_page.save_and_continue
    representatives_details_page.no_representative
    representatives_details_page.save_and_continue
    respondents_details_page.fill_in_all(respondent: respondent)

    # ACT - Click the save and continue button
    respondents_details_page.save_and_continue

    # Assert - check the error messages
    respondents_details_page.assert_error_messages phone_number: 'respondents_details.errors.invalid_phone_number'


  end
end
