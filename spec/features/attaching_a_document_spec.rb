require 'rails_helper'

feature 'Attaching a document', js: true do
  include FormMethods
  include Messages

  let(:claim) { Claim.create user: User.new(password: 'lollolol') }
  let(:file_path) { Rails.root + 'spec/support/files/' }
  let(:invalid_file_path) { file_path + './phil.jpg' }

  before do
    return_to_your_claim_page
      .load
      .return_to_your_claim claim_number: claim.reference, memorable_word: 'lollolol'
    claimants_details_page.assert_claim_retrieved_success
  end

  describe 'For claim details RTF upload' do
    let(:rtf_file_path) { file_path + './file.rtf' }
    let(:alternative_rtf_file_path) { file_path + './alt_file.rtf' }
    let(:ui_claim_details) { build(:ui_claim_details, :default) }

    context 'Uploading a valid RTF file' do
      let(:ui_claim_details) { build(:ui_claim_details, :default, rtf_file_path: rtf_file_path) }
      before do
        claim_details_page
          .load
          .fill_in_all(claim_details: ui_claim_details)
          .save_and_continue
      end

      scenario 'Attaching the file' do
        expect(claim.reload.claim_details_rtf_file.read).to eq File.read(rtf_file_path)
      end

      scenario 'Deleting the file' do
        claim_details_page
          .load
          .remove_rtf_file
          .save_and_continue

        expect(claim.reload.claim_details_rtf.present?).to be false
      end

      scenario 'Replacing the file' do
        ui_claim_details.rtf_file_path = alternative_rtf_file_path
        claim_details_page
          .load
          .fill_in_all(claim_details: ui_claim_details)
          .save_and_continue

        expect(claim.reload.claim_details_rtf_file.read).to eq File.read(alternative_rtf_file_path)
      end
    end

    scenario 'Uploading a non text file' do
      ui_claim_details.rtf_file_path = invalid_file_path
      claim_details_page
        .load
        .fill_in_all(claim_details: ui_claim_details)
        .save_and_continue

      expect(page).to have_text('is not an RTF')
      expect(claim.claim_details_rtf).not_to be_present
      expect(page.find("details")).to be_visible
    end
  end

  describe 'For additional claimants' do
    let(:csv_file_path) { file_path + './file.csv' }
    let(:alternative_csv_file_path) { file_path + './alt_file.csv' }

    context 'A valid CSV file' do
      before do
        group_claims_upload_page.load
        group_claims_upload_page.upload_secondary_claimants_csv(csv_file_path).save_and_continue
      end

      scenario 'Attaching the file' do
        expect(claim.reload.additional_claimants_csv_file.read).to eq File.read(csv_file_path)
      end

      scenario 'Deleting the file' do
        visit '/apply/additional-claimants-upload'
        sleep 2
        group_claims_upload_page.remove_csv_file
        click_button 'Save and continue'

        expect(claim.reload.additional_claimants_csv_file.present?).to be false
      end

      scenario 'Replacing the file' do
        group_claims_upload_page.load
        group_claims_upload_page.upload_secondary_claimants_csv(alternative_csv_file_path).save_and_continue

        expect(claim.reload.additional_claimants_csv_file.read).to eq File.read(alternative_csv_file_path)
      end
    end

    context 'An invalid file' do
      let(:invalid_csv_path) { file_path + './invalid_file.csv' }

      scenario 'Uploading a CSV file with errors' do
        group_claims_upload_page.load
        group_claims_upload_page.upload_secondary_claimants_csv(invalid_csv_path).save_and_continue

        expect(page).to have_text('An error has been found on line 4 of the uploaded file.')
        expect(page).to have_text('Postcode - Enter a valid UK postcode. If you live abroad, enter SW55 9QT')
        expect(page).to have_text('Date of birth - Enter the claimant’s date of birth in the correct format (DD/MM/YYYY)')
        expect(claim.additional_claimants_csv).not_to be_present
      end

      scenario 'Uploading a file not of a CSV type', js:true do
        group_claims_upload_page.load
        group_claims_upload_page.upload_secondary_claimants_csv(invalid_file_path).save_and_continue

        expect(page).to have_text('is not a CSV')
        expect(claim.additional_claimants_csv).not_to be_present
      end
    end
  end
end
