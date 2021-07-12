module ET1
  module Test
    class ClaimOutcomeUi
      attr_accessor :what_do_you_want, :notes
    end
  end
end
FactoryBot.define do
  factory :ui_claim_outcome, class: ::ET1::Test::ClaimOutcomeUi do
    trait :mandatory do
    end

    trait :default do
      mandatory
      what_do_you_want { [:'claim_outcome.what_do_you_want.options.compensation'] }
      notes { 'i would like a gold chain' }
    end
  end
end
