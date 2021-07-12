module ET1
  module Test
    class SecondaryClaimantUi < ActiveSupport::OrderedOptions

    end
  end
end
FactoryBot.define do
  factory :ui_secondary_claimant, class: ::ET1::Test::SecondaryClaimantUi do
    trait :mandatory do
      first_name { 'first' }
      sequence(:last_name) { |idx| "last#{idx}" }
      date_of_birth { '29/11/1998' }

      address_building { '32' }
      address_street { 'My Street' }
      address_town { 'London' }
      address_county { 'Greater London' }
      address_post_code { 'NE1 6WW' }
    end

    trait :default do
      mandatory
      title { :'claimants_details.title.options.Mr' }
    end
  end
end
