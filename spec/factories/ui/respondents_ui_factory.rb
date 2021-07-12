module ET1
  module Test
    RespondentUi = Struct.new('RespondentUi', :name, :address_building, :address_street, :address_town, :address_county, :address_post_code, :worked_at_same_address, :work_address_building, :work_address_street, :work_address_town, :work_address_county, :work_address_post_code, :phone_number, :work_address_phone_number, :acas_number, :dont_have_acas_number, :dont_have_acas_number_reason, keyword_init: true)
  end
end
FactoryBot.define do
  factory :ui_respondent, class: ::ET1::Test::RespondentUi do
    trait :mandatory do
      name { 'Dodgy Co' }
      address_building { '32' }
      address_street { 'My Street' }
      address_town { 'London' }
      address_county { 'Greater London' }
      address_post_code { 'NE1 6WW' }
      worked_at_same_address { :'respondents_details.worked_at_same_address.options.yes' }
      acas_number { 'AB123456/12/34' }
    end

    trait :default do
      mandatory
      phone_number { '01332 111222' }
    end

    trait :dont_have_acas do
      dont_have_acas_number { true }
      dont_have_acas_number_reason { :'respondents_details.dont_have_acas_number_reason.options.joint_claimant_has_acas_number' }
    end

    trait :interim_relief do
      dont_have_acas_number_reason { :'respondents_details.dont_have_acas_number_reason.options.interim_relief' }
    end
  end
end
