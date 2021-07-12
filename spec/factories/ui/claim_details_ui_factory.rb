module ET1
  module Test
    ClaimDetailsUi = Struct.new('ClaimDetailsUi', :text, :rtf_file_path, :other_known_claimants, :other_known_claimant_names, keyword_init: true)
  end
end
FactoryBot.define do
  factory :ui_claim_details, class: ::ET1::Test::ClaimDetailsUi do
    trait :mandatory do
      text { 'Claim details text' }
      rtf_file_path { nil }
      other_known_claimants { :'claim_details.other_known_claimants.options.no' }
      other_known_claimant_names { nil }
    end

    trait :default do
      mandatory
    end

    trait :test do
      text { 'Everybody hates me' }
      other_known_claimants { :'claim_details.other_known_claimants.options.yes' }
      other_known_claimant_names { 'Charles, Faz & Stevie' }
    end
  end
end
