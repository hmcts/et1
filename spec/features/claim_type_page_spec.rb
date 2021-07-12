require 'rails_helper'

feature 'Claim type page', js: true do
  include FormMethods

  let(:claim) { Claim.create user: User.new(password: 'lollolol') }

  before do
    return_to_your_claim_page.load
      .return_to_your_claim(claim_number: claim.reference, memorable_word: 'lollolol')
    claimants_details_page.assert_claim_retrieved_success
  end

  describe 'Claim type' do
    before do
      about_the_claim_page.load
    end

    scenario "I don’t need the words optional against specific types of claim" do
      about_the_claim_page.assert_questions
      .whistle_blowing_fieldset.whistle_blowing_question.set(:'claim_type.is_whistleblowing.options.true')
      expect(about_the_claim_page.whistle_blowing_fieldset).to have_whistle_blowing_body_question
      about_the_claim_page.save_and_continue
      expect(claim_details_page).to be_displayed
    end

  end
end
