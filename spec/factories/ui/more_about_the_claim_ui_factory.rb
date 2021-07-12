module ET1
  module Test
    class MoreAboutTheClaimUi
      attr_accessor :provide_more_information, :more_information
    end
  end
end
FactoryBot.define do
  factory :ui_more_about_the_claim, class: ::ET1::Test::MoreAboutTheClaimUi do
    trait :mandatory do
    end

    trait :default do
      mandatory
      provide_more_information { :'more_about_the_claim.provide_more_information.options.true' }
      more_information { 'better late than never' }
    end
  end
end
