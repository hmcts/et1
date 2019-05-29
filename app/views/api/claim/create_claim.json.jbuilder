# frozen_string_literal: true

json.uuid uuid
json.command 'SerialSequence'
json.data do
  json.child! do
    json.partial! 'api/claim/build_claim', claim: claim, office: office, employment: employment
  end
  json.child! do
    json.partial! 'api/claim/build_primary_claimant', claimant: claim.primary_claimant
  end
  json.child! do
    json.partial! 'api/claim/build_primary_respondent', respondent: claim.primary_respondent
  end
  if claim.representative.present?
    json.child! do
      json.partial! 'api/claim/build_primary_representative', representative: claim.representative
    end
  end
  if claim.secondary_claimants.present?
    json.child! do
      json.partial! 'api/claim/build_secondary_claimants', claimants: claim.secondary_claimants
    end
  end
  if claim.secondary_respondents.present?
    json.child! do
      json.partial! 'api/claim/build_secondary_respondents', respondents: claim.secondary_respondents
    end
  end
  if claim.additional_claimants_csv.present?
    json.child! do
      json.partial! 'api/claim/build_claimants_file', file: claim.additional_claimants_csv
    end
  end
  if claim.uploaded_file_key.present?
    json.child! do
      json.partial! 'api/claim/build_claim_details_file', claim: claim
    end
  end
  json.child! do
    json.partial! 'api/claim/build_pdf_file', file: claim.pdf
  end
end
