module ET1
  module Test
    SecondaryRespondentUi = Struct.new('RespondentUi', :name, :address_building, :address_street, :address_town, :address_county, :address_post_code, :acas_number, :dont_have_acas_number, :dont_have_acas_number_reason, keyword_init: true)
  end
end
FactoryBot.define do
  factory :ui_secondary_respondent, class: ::ET1::Test::SecondaryRespondentUi do
    trait :mandatory do
      name { 'Dodgy Co' }
      address_building { '32' }
      address_street { 'My Street' }
      address_town { 'London' }
      address_county { 'Greater London' }
      address_post_code { 'NE1 6WW' }
      acas_number { 'AB123456/12/34' }
    end

    trait :default do
      mandatory
    end

    trait :dont_have_acas do
      dont_have_acas_number { :'respondents_details.dont_have_acas_number.options.yes' }
      dont_have_acas_number_reason { :'respondents_details.dont_have_acas_number_reason.options.joint_claimant_has_acas_number' }
    end
  end
end
