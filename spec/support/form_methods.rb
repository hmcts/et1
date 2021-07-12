module FormMethods
  SAVE_AND_RETURN_EMAIL = 'mail@example.com'.freeze
  CLAIMANT_EMAIL = 'barrington@example.com'.freeze
  REPRESENTATIVE_EMAIL = 'rep@example.com'.freeze

  extend ActiveSupport::Concern

  def start_claim
    ET1::Test::ApplyPage.new.load.start_a_claim
  end

  def end_session
    click_button 'Save and complete later'
    click_button 'Sign out now'
  end

  def fill_in_return_form(reference, word)
    visit new_user_session_path
    fill_in 'Save and return number', with: reference
    fill_in 'Memorable word', with: word
    click_button 'Find my claim'
  end

  def fill_in_personal_details(options = {})
    select 'Mr', from: 'Title'

    fill_in 'First name', with: 'Barrington'
    fill_in 'Last name',  with: 'Wrigglesworth'

    choose 'Male'

    fill_in 'Day',   with: '15'
    fill_in 'Month', with: '01'
    fill_in 'Year',  with: '1985'

    fill_in_address with_country: true

    fill_in 'Alternative phone',   with: '07956000000'

    if options[:claimant_email] == false
      choose 'claimant_contact_preference_post'
    else
      choose  'claimant_contact_preference_email'
      fill_in 'Email address', with: CLAIMANT_EMAIL
    end

    choose 'claimant_allow_video_attendance_true'

    choose  'claimant_has_special_needs_true'
    fill_in 'Describe the assistance you require', with: 'I am blind.'

    click_button 'Save and continue' unless options[:submit_form] == false
  end

  def fill_in_additional_claimant_details(options = {})
    if options[:additional_claimants]
      choose "Yes"

      select 'Mr', from: 'Title'
      fill_in 'First name', with: 'Edmund'
      fill_in 'Last name',  with: 'Wrigglesworth'
      fill_in 'Day',   with: '22'
      fill_in 'Month', with: '01'
      fill_in 'Year',  with: '1985'
      fill_in 'Building number or name', with: '2'
      fill_in 'Street',                  with: 'High street'
      fill_in 'Town/city',               with: 'Anytown'
      fill_in 'County',                  with: 'Anyfordshire'
      fill_in 'Postcode',                with: 'AT1 4PQ'
    else
      choose "No"
    end

    click_button 'Save and continue'
  end

  def fill_in_additional_claimant_jump_to_csv_upload
    choose "Yes"
    click_link "spreadsheet"
  end

  def fill_in_additional_claimants_upload_details
    choose "No"
    click_button "Save and continue"
  end

  def fill_in_representative_details
    choose 'representative_has_representative_true'
    select 'Solicitor', from: 'representative_type'
    fill_in "Name of the representative’s organisation", with: 'Better Call Saul'
    fill_in "Representative’s name", with: 'Saul Goodman'

    fill_in_address

    fill_in 'Alternative phone',   with: '07956000000'
    fill_in 'Email address', with: REPRESENTATIVE_EMAIL
    fill_in 'Document exchange (DX) number', with: '1'
    choose 'representative_contact_preference_post'

    click_button 'Save and continue'
  end

  def fill_in_address(with_country: false)
    fill_in 'Building number or name', with: '1'
    fill_in 'Street',                  with: 'High street'
    fill_in 'Town/city',               with: 'Anytown'
    fill_in 'County',                  with: 'Anyfordshire'
    fill_in 'Postcode',                with: 'AT1 4PQ'
    fill_in 'Phone',                   with: '01234567890'
    select  'United Kingdom',          from: 'Country' if with_country
  end

  def fill_in_additional_respondent_details
    choose "No"
    click_button 'Save and continue'
  end

  def fill_in_pre_claim_pages
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
    employment_details_page.fill_in_all(employment: ui_employment)
    employment_details_page.save_and_continue
  end

  def fill_in_claim_details
    fill_in 'claim_details_claim_details',
      with: "Everybody hates me"
    choose 'claim_details_other_known_claimants_true'
    fill_in 'You can add the names of other people here. (optional)',
      with: 'Charles, Faz & Stevie'

    click_button 'Save and continue'
  end

  def fill_in_your_fee(options = {})
    if options[:additional_claimants]
      fill_in 'How many in your group want to apply for help with fees?',
        with: options[:seeking_remissions]
    else
      choose "your_fee_applying_for_remission_#{options.fetch(:seeking_remissions) { false }}"
    end

    click_button 'Save and continue'
  end

  def complete_a_claim
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
    additional_respondents_page.no_secondary_respondents
    additional_respondents_page.save_and_continue
    employment_details_page.fill_in_all(employment: ui_employment)
    employment_details_page.save_and_continue
    about_the_claim_page.fill_in_all(claim_type: ui_claim_type)
    about_the_claim_page.save_and_continue
    claim_details_page.fill_in_all(claim_details: ui_claim_details)
    claim_details_page.save_and_continue
    claim_outcome_page.fill_in_all(claim_outcome: ui_claim_outcome).save_and_continue
    more_about_the_claim_page.fill_in_all(more_about_the_claim: ui_more_about_the_claim).save_and_continue
  end

  def complete_and_submit_claim
    complete_a_claim
    click_button "Submit claim"
  end

  def deselect_claimant_email
    uncheck CLAIMANT_EMAIL
  end

  def deselect_representative_email
    uncheck REPRESENTATIVE_EMAIL
  end
end
