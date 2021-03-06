module ET1
  module Test
    class ClaimantUi
      attr_accessor :title, :first_name, :last_name, :date_of_birth, :gender, :has_special_needs, :special_needs
      attr_accessor :address_building, :address_street, :address_town, :address_county, :address_post_code, :address_country
      attr_accessor :phone_or_mobile_number, :alternative_phone_or_mobile_number, :email_address
      attr_accessor :best_correspondence_method, :allow_video_attendance

    end
  end
end
FactoryBot.define do
  factory :ui_claimant, class: ::ET1::Test::ClaimantUi do
    trait :mandatory do
      first_name { 'first' }
      last_name { 'last' }
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
      email_address { 'email@address.com' }
      best_correspondence_method { :'claimants_details.best_correspondence_method.options.email' }
      allow_video_attendance { :'claimants_details.allow_video_attendance.options.yes' }
    end
  end
end
