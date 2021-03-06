module ET1
  module Test
    class RespondentUi
      attr_accessor :name
      attr_accessor :address_building, :address_street, :address_town, :address_county, :address_post_code
      attr_accessor :worked_at_same_address
      attr_accessor :work_address_building, :work_address_street, :work_address_town, :work_address_county, :work_address_post_code
      attr_accessor :phone_number, :work_address_phone_number, :acas_number, :dont_have_acas_number, :dont_have_acas_number_reason
    end
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
      acas_number { '1234567890' }
    end

    trait :default do
      mandatory
      phone_number { '01332 111222' }
    end
  end
end
