module ET1
  module Test
    class ClaimantUi < ActiveSupport::OrderedOptions

    end
  end
end
FactoryBot.define do
  factory :ui_claimant, class: ::ET1::Test::ClaimantUi do
    trait :mandatory do
      title { :'claimants_details.title.options.unselected' }
      first_name { 'first' }
      sequence(:last_name) { |idx| "last#{idx}" }
      date_of_birth { '29/11/1998' }

      address_building { '32' }
      address_street { 'My Street' }
      address_town { 'London' }
      address_county { 'Greater London' }
      address_post_code { 'NE1 6WW' }
      address_country { :'claimants_details.country.options.united_kingdom' }
      best_correspondence_method { :'claimants_details.best_correspondence_method.options.post' }
      allow_video_attendance { :'claimants_details.allow_video_attendance.options.yes' }
    end

    trait :default do
      mandatory
      title { :'claimants_details.title.options.Mr' }
      gender { :'claimants_details.gender.options.male' }
      has_special_needs { :'claimants_details.has_special_needs.options.yes' }
      special_needs { "I need all the documents in braille" }
      phone_or_mobile_number { '01332 111222' }
      alternative_phone_or_mobile_number { '01332 222333' }
      email_address { 'barrington@example.com' }
      best_correspondence_method { :'claimants_details.best_correspondence_method.options.email' }
      allow_video_attendance { :'claimants_details.allow_video_attendance.options.yes' }
    end

    trait :under_age do
      date_of_birth { "1/1/#{15.years.ago.year}" }
    end

    trait :no_date_of_birth do
      date_of_birth { nil }
    end

    trait :date_of_birth_two_digit do
      date_of_birth { '1/1/12' }
    end

    trait :no_allow_video_attendance do
      allow_video_attendance { nil }
    end
  end
end
