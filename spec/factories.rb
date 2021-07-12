FactoryBot.define do
  factory :claim do
    association :primary_claimant,   factory: :claimant, primary_claimant: true
    association :primary_respondent, factory: :respondent
    association :representative
    association :employment
    association :office

    state { 'enqueued_for_submission' }

    is_unfair_dismissal { true }

    claim_details_rtf do
      Rack::Test::UploadedFile.new 'spec/support/files/file.rtf'
    end

    additional_claimants_csv do
      Rack::Test::UploadedFile.new 'spec/support/files/file.csv'
    end

    fee_group_reference { "511234567800" }

    additional_claimants_csv_record_count { 5 }

    claim_details             { 'I am sad' }
    other_claim_details       { 'Really sad' }
    other_outcome             { 'I wanna take him to the cleaners!' }
    is_whistleblowing         { false }
    miscellaneous_information { 'Still really sad' }

    discrimination_claims  { [:sex_including_equal_pay, :disability, :race] }
    pay_claims             { [:redundancy, :notice, :holiday, :arrears, :other] }
    desired_outcomes       { [:compensation_only, :tribunal_recommendation] }

    user { build(:user, password: 'lollolol') }

    submitted_at { Time.current }

    trait :not_submitted do
      submitted_at { nil }
      state        { 'created' }
    end

    trait :submitted do
      state { 'submitted' }
    end

    trait :single_claimant do
      without_additional_claimants_csv
      after(:create) { |claim| claim.secondary_claimants.clear }
    end

    trait :null_primary_claimant do
      primary_claimant do
        build :claimant,
          address_telephone_number: nil,
          mobile_number: nil,
          email_address: nil,
          fax_number: nil,
          contact_preference: nil,
          gender: nil, date_of_birth: nil
      end
    end

    trait :without_additional_claimants_csv do
      additional_claimants_csv { nil }
      additional_claimants_csv_record_count { 0 }
    end

    trait :without_rtf do
      claim_details_rtf { nil }
    end


    trait :without_representative do
      representative { nil }
    end

    trait :without_employment do
      employment { nil }
    end

    trait :null_representative do
      representative do
        build :representative,
          address_telephone_number: nil,
          mobile_number: nil,
          email_address: nil,
          dx_number: nil
      end
    end

    trait :primary_respondent_with_no_work_address do
      primary_respondent do
        build(:respondent, addresses: [build(:address, primary: true)])
      end
    end

    trait :primary_respondent_with_no_addresses do
      primary_respondent do
        build(:respondent, addresses: [build(:address, primary: true)])
      end
    end

    trait :primary_representative_with_no_address do
      representative do
        build(:representative, address: nil)
      end
    end

    trait :with_pdf do
      pdf_url { 'http://example.com/my-pdf.pdf' }
    end

    trait :with_secondary_claimants do
      after(:create) { |claim| create_list :claimant, 2, claim: claim }
    end

    trait :with_secondary_respondents do
      after(:build) do |claim|
        claim.secondary_respondents.build(attributes_for(:respondent, primary_respondent: false))
        claim.secondary_respondents.build(attributes_for(:respondent, primary_respondent: false))
      end
    end

    trait :no_fee_group_reference do
      office { nil }
      fee_group_reference { nil }
    end

    trait :no_attachments do
      claim_details_rtf { nil }
      additional_claimants_csv { nil }
      additional_claimants_csv_record_count { 0 }
    end

    trait :non_sanitized_attachment_filenames do
      additional_claimants_csv do
        Rack::Test::UploadedFile.new 'spec/support/files/file-l_o_l.biz._v1_.csv'
      end

      claim_details_rtf do
        Rack::Test::UploadedFile.new 'spec/support/files/file-l_o_l.biz._v1_.rtf'
      end
    end

    trait :respondent_with_acas_number do
      association :primary_respondent, factory: [:respondent, :with_acas_number]
    end
  end

  factory :claimant do
    association :address, country: 'united_kingdom'

    title      { 'Mr' }
    first_name { 'Barrington' }
    last_name  { 'Wrigglesworth' }
    gender     { 'male' }

    date_of_birth { Date.civil(1960, 6, 6) }

    mobile_number      { '07956273434' }
    contact_preference { 'email' }
    allow_video_attendance { true }
    email_address      { "#{first_name}.#{last_name}@example.com" }
  end

  factory :address do
    building  { '102' }
    street    { 'Petty France' }
    locality  { 'London' }
    county    { 'Greater London' }
    post_code { 'SW1A 1AH' }

    telephone_number { '020 7123 4567' }
  end

  factory :representative do
    association :address

    type              { "law_centre" }
    name              { "Saul Goodman" }
    organisation_name { "Better Call Saul" }
    dx_number         { "1234" }
    contact_preference { 'post' }
  end

  factory :respondent do
    primary_respondent      { true }
    name                    { "Ministry of Justice" }
    no_acas_number_reason   { "employer_contacted_acas" }
    no_acas_number          { true }
    worked_at_same_address  { false }
    addresses               { [build(:address, primary: true), build(:address, primary: false)] }

    trait :with_acas_number do
      no_acas_number { false }
      no_acas_number_reason { nil }
      acas_early_conciliation_certificate_number { "SOMEACASNUMBER" }
    end

    trait :without_work_address do
      addresses { [build(:address, primary: true)] }
    end
  end

  factory :office do
    code      { 11 }
    name      { "Birmingham" }
    address   { "Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU" }
    telephone { "0121 600 7780" }
    email     { "email@example.com" }
  end

  factory :employment do
    enrolled_in_pension_scheme           { true }
    found_new_job                        { false }
    worked_notice_period_or_paid_in_lieu { false }
    end_date                             { 3.weeks.ago }
    new_job_start_date                   { 3.days.ago }
    start_date                           { 10.years.ago }
    gross_pay                            { 4000 }
    net_pay                              { 3000 }
    new_job_gross_pay                    { 4000 }
    average_hours_worked_per_week        { 37.5 }
    current_situation                    { "employment_terminated" }
    pay_period_type                      { "monthly" }
    job_title                            { "tea boy" }
    benefit_details                      { "All the justice you can eat" }
  end

  factory :refund do
    sequence(:applicant_email_address)    { |n| "tester#{n}@domain.com" }
    accept_declaration                    { true }
    address_changed                       { true }
    has_name_changed                      { false }
    profile_type                          { 'claimant_direct_not_reimbursed' }
    et_country_of_claim                   { 'england_and_wales' }
    et_case_number                        { '1234567/2016' }
    eat_case_number                       { 'UKEAT/2016/06/123' }
    et_tribunal_office                    { 'unknown' }
    sequence(:application_reference_number) { |n| n }
    application_reference                 { "C#{application_reference_number}" }
    respondent_name                       { 'Mr Resp' }
    respondent_address_building           { '26' }
    respondent_address_street             { 'Street' }
    respondent_address_locality           { 'Locality' }
    respondent_address_county             { 'County' }
    respondent_address_post_code          { 'DE22 1ZY' }
    claim_had_representative              { true }
    representative_name                   { 'Mr Rep' }
    representative_address_building       { '28' }
    representative_address_street         { 'Rep Street' }
    representative_address_locality       { 'Rep Locality' }
    representative_address_county         { 'Rep County' }
    representative_address_post_code      { 'DE23 1ZY' }
    claimant_name                         { 'Mr Claimant' }
    claimant_address_building             { '30' }
    claimant_address_street               { 'Claimant Street' }
    claimant_address_locality             { 'Claimant Locality' }
    claimant_address_county               { 'Claimant County' }
    claimant_address_post_code            { 'DE24 1ZY' }
    applicant_address_building            { '30' }
    applicant_address_street              { 'Applicant Street' }
    applicant_address_locality            { 'Applicant Locality' }
    applicant_address_county              { 'Applicant County' }
    applicant_address_post_code           { 'DE25 1ZY' }
    applicant_address_telephone_number    { '01332 123456' }
    applicant_title                       { 'mr' }
    applicant_first_name                  { 'First' }
    applicant_last_name                   { 'Last' }
    additional_information                { 'Some extra information' }
    payment_account_type                  { 'bank' }
    submitted_at                          { DateTime.parse('1 December 2016 00:00:00').utc }
  end

  factory :diversity do
    claim_type             { "Discrimination" }
    sex                    { "Prefer not to say" }
    sexual_identity        { "Bisexual" }
    age_group              { "35-44" }
    ethnicity              { "Asian / Asian British" }
    ethnicity_subgroup     { "Chinese" }
    disability             { "No" }
    caring_responsibility  { "No" }
    gender                 { "Female (including male-to-female trans women)" }
    gender_at_birth        { "No" }
    pregnancy              { "No" }
    relationship           { "Married" }
    religion               { "Jewish" }
  end

  factory :user do
    password { 'lollolol' }
  end
end
