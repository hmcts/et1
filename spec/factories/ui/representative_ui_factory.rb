module ET1
  module Test
    class RepresentativeUi < ActiveSupport::OrderedOptions

    end
  end
end
FactoryBot.define do
  factory :ui_representative, class: ::ET1::Test::RepresentativeUi do
    trait :mandatory do
      type { :'representatives_details.type.options.solicitor' }
      name { "Naughty Boy" }
      address_building { '32' }
      address_street { 'My Street' }
      address_town { 'London' }
      address_county { 'Greater London' }
      address_post_code { 'NE1 6WW' }
      best_correspondence_method { :'representatives_details.best_correspondence_method.options.post' }
    end
    trait :default do
      mandatory
      name_of_organisation { "Dodgy Co" }
      phone_or_mobile_number { '01332 111222' }
      alternative_phone_or_mobile_number { '01332 222333' }
      email_address { 'rep@example.com' }
      dx_number { '1234567' }
    end
  end
end
