module ET1
  module Test
    class ClaimTypeUi
      attr_accessor :claim_types, :claim_type_other_details, :is_whistleblowing, :whistleblowing_forward_claim
    end
  end
end
FactoryBot.define do
  factory :ui_claim_type, class: ::ET1::Test::ClaimTypeUi do
    trait :mandatory do
    end

    trait :default do
      claim_types do
        [
          :'claim_type.unfair_dismissal.options.is_unfair_dismissal',
          :'claim_type.discrimination.options.sex_including_equal_pay',
          :'claim_type.other.options.other_type_of_claim'
        ]
      end

      claim_type_other_details { 'Boss was a bit of a douchenozzle TBH' }
      is_whistleblowing { :'claim_type.is_whistleblowing.options.true' }
      whistleblowing_forward_claim { :'claim_type.send_claim_to_whistleblowing_entity.options.true' }
    end
  end
end
