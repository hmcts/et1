json.uuid SecureRandom.uuid
json.command 'BuildClaimDetailsFile'
json.data do
  json.filename claim.uploaded_file_name
  json.checksum nil
  json.data_url nil
  json.data_from_key claim.uploaded_file_key
end
