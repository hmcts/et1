require 'rails_helper'
RSpec.describe 'Representatives Details Validation', type: :feature, js: true do
  it 'filters out an incorrect phone number and provides the correct message' do
    # Arrange - get to the page loaded with a claimant with the phone number overridden
    claimant = build(:ui_claimant, :mandatory)
    representative = build(:ui_representative, :mandatory, phone_or_mobile_number: 'somethingwromg', alternative_phone_or_mobile_number: 'something_wrong')

    apply_page.load
    apply_page.start_a_claim
    saving_your_claim_page.register(email_address: 'fred@bloggs.com', password: 'password')
    claimants_details_page.fill_in_all(claimant: claimant)
    claimants_details_page.save_and_continue
    group_claims_page.no_secondary_claimants
    group_claims_page.save_and_continue
    representatives_details_page.fill_in_all(representative: representative)

    # ACT - Click the save and continue button
    representatives_details_page.save_and_continue

    # Assert - check the error messages
    representatives_details_page.assert_error_messages phone_or_mobile_number: 'representatives_details.errors.invalid_phone_number',
                                                 alternative_phone_or_mobile_number: 'representatives_details.errors.invalid_phone_number'


  end
end
