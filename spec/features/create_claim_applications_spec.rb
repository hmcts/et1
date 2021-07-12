require 'rails_helper'

feature 'Claim applications', type: :feature, js: true do
  include FormMethods
  include Messages
  include MailMatchers
  include ActiveJob::TestHelper
  include ActiveJobPerformHelper

  around { |example| travel_to(Date.new(2018, 9, 29)) { example.run } }
  let(:et_api_url) { 'http://api.et.net:4000/api/v2' }
  let(:build_claim_url) { "#{et_api_url}/claims/build_claim" }
  let(:example_pdf_url) { test_valid_pdf_url(host: "#{page.server.host}:#{page.server.port}") }
  let(:ui_claimant) { build(:ui_claimant, :default) }
  let(:ui_secondary_claimants) { build_list(:ui_secondary_claimant, 1, :default) }
  let(:ui_representative) { build(:ui_representative, :default) }
  let(:ui_respondent) { build(:ui_respondent, :default) }
  let(:ui_secondary_respondents) { [] }
  let(:ui_employment) { build(:ui_employment, :default) }
  let(:ui_claim_type) { build(:ui_claim_type, :default) }
  let(:ui_claim_details) { build(:ui_claim_details, :test) }
  let(:ui_claim_outcome) { build(:ui_claim_outcome, :default) }
  let(:ui_more_about_the_claim) { build(:ui_more_about_the_claim, :default) }
  around do |example|
    ClimateControl.modify ET_API_URL: et_api_url do
      example.run
    end
  end
  before do
    essential_response_data = {
      meta: {
        BuildClaim: {
          pdf_url: example_pdf_url,
          reference: "332000121100",
          office: {
            name: "Watford",
            code: 33,
            telephone: "01923 281 750",
            address: "3rd Floor, Radius House, 51 Clarendon Rd, Watford, WD17 1HP",
            email: "watfordet@justice.gov.uk"
          }
        }
      }
    }
    stub_request(:post, build_claim_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return do |request|
      { body: essential_response_data.to_json, headers: { 'Content-Type': 'application/json' } }
    end
  end


  context 'along the happy path' do
    scenario 'Hitting the start page' do
      visit '/'
      expect(apply_page).to be_displayed
      expect(apply_page).not_to have_sign_out_button
      apply_page.assert_no_session_prompt
    end

    scenario 'Create a new application', js: true do
      start_claim
      expect(saving_your_claim_page).to be_displayed
      expect(page).to have_text before_you_start_message
      expect(saving_your_claim_page).not_to have_sign_out_button
      saving_your_claim_page.assert_session_prompt
    end

    scenario 'Entering word for save and return' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')

      claim = Claim.last
      expect(claim.user.valid_password?('green')).to be true

      expect(claimants_details_page).to be_displayed
      expect(claimants_details_page).to have_sign_out_button
      claimants_details_page.assert_session_prompt
    end

    scenario 'Entering word and email for save and return', js: true do
      start_claim
      saving_your_claim_page.register(email_address: FormMethods::SAVE_AND_RETURN_EMAIL, password: 'green')

      claim = Claim.last
      expect(claim.user.valid_password?('green')).to be true

      # Run the active job job
      perform_active_jobs(ActionMailer::MailDeliveryJob)

      mail = ActionMailer::Base.deliveries.last
      expect(mail).to match_pattern claim.reference

      expect(page).to have_text claim_heading_for(:claimant)
    end

    scenario 'Entering personal details' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      expect(group_claims_page).to be_displayed
      expect(group_claims_page).to have_sign_out_button
      group_claims_page.assert_session_prompt
    end

    scenario 'Entering additional claimant details' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.fill_in_all(secondary_claimants: ui_secondary_claimants)
      group_claims_page.save_and_continue
      expect(representatives_details_page).to be_displayed
      expect(representatives_details_page).to have_sign_out_button
      representatives_details_page.assert_session_prompt
    end

    scenario "Navigating between manual and CSV upload for additional claimants" do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.provide_spreadsheet

      expect(group_claims_upload_page).to be_displayed
      expect(group_claims_upload_page).to have_sign_out_button

      group_claims_upload_page.switch_to_manual_input

      expect(group_claims_page).to be_displayed
      expect(group_claims_page).to have_sign_out_button
      group_claims_page.assert_session_prompt
    end

    scenario 'Entering additional claimant upload details' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.provide_spreadsheet.no_secondary_claimants.save_and_continue

      expect(representatives_details_page).to be_displayed
      expect(representatives_details_page).to have_sign_out_button
      representatives_details_page.assert_session_prompt
    end

    scenario 'Entering representative details' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.fill_in_all(secondary_claimants: ui_secondary_claimants)
      group_claims_page.save_and_continue
      representatives_details_page.fill_in_all(representative: ui_representative)
      representatives_details_page.save_and_continue

      expect(respondents_details_page).to be_displayed
      expect(respondents_details_page).to have_sign_out_button
      respondents_details_page.assert_session_prompt
    end

    scenario 'Display ACAS hints', js: true do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.fill_in_all(secondary_claimants: ui_secondary_claimants)
      group_claims_page.save_and_continue
      representatives_details_page.fill_in_all(representative: ui_representative)
      representatives_details_page.save_and_continue
      dont_have_acas_respondent = build(:ui_respondent, :default, :dont_have_acas)
      dont_have_acas_respondent_interim_relief = build(:ui_respondent, :dont_have_acas, :interim_relief)
      respondents_details_page
        .fill_in_all(respondent: dont_have_acas_respondent)
        .assert_correct_hints(dont_have_acas_respondent)
        .fill_in_dont_have_acas_number(dont_have_acas_respondent_interim_relief)
        .assert_correct_hints(dont_have_acas_respondent_interim_relief)
    end

    scenario 'Entering respondent details' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.fill_in_all(secondary_claimants: ui_secondary_claimants)
      group_claims_page.save_and_continue
      representatives_details_page.fill_in_all(representative: ui_representative)
      representatives_details_page.save_and_continue
      respondents_details_page.fill_in_all(respondent: ui_respondent)
      respondents_details_page.save_and_continue

      expect(additional_respondents_page).to be_displayed
      expect(additional_respondents_page).to have_signout_button
      additional_respondents_page.assert_session_prompt
    end

    scenario 'Entering additional respondent details' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.fill_in_all(secondary_claimants: ui_secondary_claimants)
      group_claims_page.save_and_continue
      representatives_details_page.fill_in_all(representative: ui_representative)
      representatives_details_page.save_and_continue
      #fill_in_representative_details
      respondents_details_page.fill_in_all(respondent: ui_respondent)
      respondents_details_page.save_and_continue
      additional_respondents_page.no_secondary_respondents
      additional_respondents_page.save_and_continue

      expect(employment_details_page).to be_displayed
      expect(employment_details_page).to have_sign_out_button
      employment_details_page.assert_session_prompt
    end

    scenario 'Entering employment details' do
      start_claim
      saving_your_claim_page.register(email_address: nil, password: 'green')
      claimants_details_page.fill_in_all(claimant: ui_claimant)
      claimants_details_page.save_and_continue
      group_claims_page.fill_in_all(secondary_claimants: ui_secondary_claimants)
      group_claims_page.save_and_continue
      representatives_details_page.fill_in_all(representative: ui_representative)
      representatives_details_page.save_and_continue
      respondents_details_page.fill_in_all(respondent: ui_respondent)
      respondents_details_page.save_and_continue
      additional_respondents_page.fill_in_all(secondary_respondents: ui_secondary_respondents)
      additional_respondents_page.save_and_continue

      expect(employment_details_page).to be_displayed
      expect(employment_details_page).to have_sign_out_button
      employment_details_page.assert_session_prompt
    end

    scenario 'Entering claim type details' do
      start_claim

      fill_in_pre_claim_pages

      about_the_claim_page.fill_in_all(claim_type: ui_claim_type)
      about_the_claim_page.save_and_continue

      expect(claim_details_page).to be_displayed
      expect(claim_details_page).to have_sign_out_button
      claim_details_page.assert_session_prompt
    end

    scenario 'Entering claim details' do
      fill_in_pre_claim_pages
      about_the_claim_page.fill_in_all(claim_type: ui_claim_type)
      about_the_claim_page.save_and_continue
      claim_details_page.fill_in_all(claim_details: ui_claim_details)
      claim_details_page.save_and_continue

      expect(claim_outcome_page).to be_displayed
      expect(claim_outcome_page).to have_sign_out_button
      claim_outcome_page.assert_session_prompt
    end

    scenario 'Entering claim outcome details' do
      fill_in_pre_claim_pages
      about_the_claim_page.fill_in_all(claim_type: ui_claim_type)
      about_the_claim_page.save_and_continue
      claim_details_page.fill_in_all(claim_details: ui_claim_details)
      claim_details_page.save_and_continue
      claim_outcome_page.fill_in_all(claim_outcome: ui_claim_outcome).save_and_continue

      expect(more_about_the_claim_page).to be_displayed
      expect(more_about_the_claim_page).to have_sign_out_button
      more_about_the_claim_page.assert_session_prompt
    end

    scenario 'Entering additonal information' do
      fill_in_pre_claim_pages
      about_the_claim_page.fill_in_all(claim_type: ui_claim_type)
      about_the_claim_page.save_and_continue
      claim_details_page.fill_in_all(claim_details: ui_claim_details)
      claim_details_page.save_and_continue
      claim_outcome_page.fill_in_all(claim_outcome: ui_claim_outcome).save_and_continue
      more_about_the_claim_page.fill_in_all(more_about_the_claim: ui_more_about_the_claim).save_and_continue

      expect(check_your_claim_page).to have_sign_out_button
      check_your_claim_page.assert_session_prompt
    end

    scenario 'Entering your fee details' do
      fill_in_pre_claim_pages
      about_the_claim_page.fill_in_all(claim_type: ui_claim_type)
      about_the_claim_page.save_and_continue
      claim_details_page.fill_in_all(claim_details: ui_claim_details)
      claim_details_page.save_and_continue
      claim_outcome_page.fill_in_all(claim_outcome: ui_claim_outcome).save_and_continue
      more_about_the_claim_page.fill_in_all(more_about_the_claim: ui_more_about_the_claim).save_and_continue
      expect(check_your_claim_page).to be_displayed
      expect(check_your_claim_page).to have_sign_out_button
      check_your_claim_page.assert_session_prompt
    end

    scenario 'Signout from claim review page' do
      complete_a_claim

      expect(check_your_claim_page).to be_displayed
      expect(check_your_claim_page).to have_sign_out_button
      check_your_claim_page.assert_session_prompt
    end

    scenario 'Saving the confirmation email recipients' do
      complete_a_claim
      click_button 'Submit claim'
      sleep 2

      expect(Claim.last.confirmation_email_recipients).
        to eq [FormMethods::REPRESENTATIVE_EMAIL]
    end

    scenario 'Deselecting email confirmation recipients before submission' do
      complete_a_claim
      review_page.email_confirmation_section.email_recipients.set([])
      click_button 'Submit claim'

      expect(Claim.last.confirmation_email_recipients).to be_empty
    end

    scenario 'Submitting the claim' do
      complete_a_claim
      click_button 'Submit claim'

      expect(claim_submitted_page).to be_displayed
      expect(page).to have_text "Claim submitted"
      expect(page).to have_text "Watford, watfordet@justice.gov.uk, 01923 281 750"
      expect(claim_submitted_page).not_to have_sign_out_button
      claim_submitted_page.assert_no_session_prompt
    end

    scenario 'attempting a new claim after submission' do
      complete_a_claim
      click_button 'Submit claim'

      expect(page).to have_text "Claim submitted"
      claim_submitted_page.home
      apply_page.start_a_claim
      expect(saving_your_claim_page).to be_displayed
    end
    scenario 'Validating the API calls claimant data' do
      complete_a_claim
      click_button 'Submit claim'
      expect(a_request(:post, build_claim_url).
        with do |request|
        claimant = JSON.parse(request.body)['data'].detect { |cmd| cmd['command'] == 'BuildPrimaryClaimant' }['data']
        expect(claimant).to include "title" => ET1::Test::I18n.t(ui_claimant.title),
                                    "first_name" => ui_claimant.first_name,
                                    "last_name" => ui_claimant.last_name,
                                    "address_attributes" => a_hash_including(
                                      "building" => ui_claimant.address_building,
                                      "street" => ui_claimant.address_street,
                                      "locality" => ui_claimant.address_town,
                                      "county" => ui_claimant.address_county,
                                      "post_code" => ui_claimant.address_post_code,
                                      "country" => ET1::Test::I18n.t(ui_claimant.address_country)
                                    ),
                                    "address_telephone_number" => ui_claimant.phone_or_mobile_number,
                                    "mobile_number" => ui_claimant.alternative_phone_or_mobile_number,
                                    "email_address" => ui_claimant.email_address,
                                    "contact_preference" => ET1::Test::I18n.t(ui_claimant.best_correspondence_method),
                                    "allow_video_attendance" => ui_claimant.allow_video_attendance.to_s.split('.').last == 'yes',
                                    "gender" => ET1::Test::I18n.t(ui_claimant.gender),
                                    "date_of_birth" => Date.parse(ui_claimant.date_of_birth).strftime('%Y-%m-%d'),
                                    "special_needs" => ui_claimant.special_needs
      end).to have_been_made
    end

    context 'Downloading the PDF', js: true do
      scenario 'when the file is available' do
        complete_a_claim
        click_button 'Submit claim'
        expect(claim_submitted_page).to have_save_a_copy_link
        expect(claim_submitted_page).not_to have_invalid_save_a_copy_link
      end

      context 'with pdf not ready yet' do
        let(:example_pdf_url) { test_invalid_pdf_url(host: "#{page.server.host}:#{page.server.port}") }

        scenario 'when the file is unavailable' do
          complete_a_claim
          click_button 'Submit claim'
          expect(claim_submitted_page).to have_invalid_save_a_copy_link
          expect(claim_submitted_page).not_to have_save_a_copy_link
        end
      end
    end

    context 'Viewing the confirmation page' do
      scenario 'with a single claimant without remission option' do
        complete_a_claim
        expect(page).to have_text 'Check your claim'

        within('#main-content') do
          expect(page).not_to have_text 'Your fee '
          expect(page).not_to have_text 'Help with fees'
        end

        click_button 'Submit claim', exact: true
        expect(page).to have_text 'Claim submitted'
      end
    end
  end
end
