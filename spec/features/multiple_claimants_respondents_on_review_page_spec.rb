require 'rails_helper'

feature 'Multiple claimants/respondents on the review page' do
  include FormMethods

  let(:claim) { Claim.create user: User.new(password: 'lollolol') }

  before do
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  context 'with no additional claimants' do
    before { visit claim_review_path }

    it "doesn't show a list of additional claimants" do
      expect(page.text).not_to match(/Claimant \d+/)
      expect(page.text).to     match(/Group claimNo/)
    end
  end

  context 'with additional claimants' do
    before do
      claim.secondary_claimants.create first_name: 'Barry', last_name: 'Obama',
                                       date_of_birth: Date.civil(2000, 1, 1), address_building: 1,
                                       address_street: 'Lol lane', address_locality: 'London',
                                       address_county: 'London', address_post_code: 'SW1 1AA'

      visit claim_review_path
    end

    it "does show a list of additional claimants" do
      text = review_page.group_claim.text

      expect(text).
        to include(
          'Claimant 2',
          'Full name', 'Barry Obama',
          'Date of birth', '01 January 2000',
          'Address', '1', 'Lol lane', 'London', 'London', 'SW1 1AA'
        )

      expect(page.text).not_to match(/Group claimNo/)
    end
  end

  context 'with no additional respondents' do
    before { visit claim_review_path }

    it "doesn't show a list of additional claimants" do
      expect(page.text).not_to match(/Respondent \d+/)
      expect(page.text).to     match(/Additional respondentsNo/)
    end
  end

  context 'with additional respondents' do
    before do
      claim.secondary_respondents.create name: 'Barry Obama',
                                         acas_early_conciliation_certificate_number: 'XX123456/12/12',
                                         address_building: 1, address_street: 'Lol lane', address_locality: 'London',
                                         address_county: 'London', address_post_code: 'SW1 1AA'

      visit claim_review_path
    end

    it "does show a list of additional respondents" do
      text = review_page.additional_respondents_section.text

      expect(text).
        to include(
          'Respondent 2',
          'Name', 'Barry Obama',
          'Acas number', 'XX123456/12/12',
          'Address', '1', 'Lol lane', 'London', 'London', 'SW1 1AA'
        )

      expect(page.text).not_to match(/Additional respondentsNo/)
    end
  end
end
