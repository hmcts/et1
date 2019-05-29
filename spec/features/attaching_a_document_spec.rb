require 'rails_helper'

feature 'Attaching a document', js: true do
  include FormMethods
  include Messages
  include ET1::Test::Pages
  include ET1::Test::Setup

  let(:claim) { Claim.create password: 'lollolol' }
  let(:file_path) { Rails.root + 'spec/support/files/' }
  let(:invalid_file_path) { file_path + './phil.jpg' }

  before do
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  describe 'For claim details RTF upload' do
    let(:rtf_file_path) { file_path + './file.rtf' }
    let(:alternative_rtf_file_path) { file_path + './alt_file.rtf' }

    context 'Uploading a valid RTF file' do

      let(:claim_from_db) { Claim.find(claim.id) }

      before do
        stub_build_blob_to_azure
        claim_details_page.load
        claim_details_page.rtf_file_upload.expand
        claim_details_page.rtf_file_upload.attach_additional_information_file(rtf_file_path)
        fill_in_claim_details
      end

      it 'saves the file name' do
        expect(claim_from_db.uploaded_file_name).to eq 'file.rtf'
      end

      scenario 'Deleting the file' do
        claim_details_page.load
        claim_details_page.rtf_file_upload.remove_rtf
        claim_details_page.next

        expect(claim_from_db.uploaded_file_name.present?).to be false
      end

      it 'replaces an existing file with a new upload' do
        claim_details_page.load
        claim_details_page.rtf_file_upload.expand
        claim_details_page.rtf_file_upload.attach_additional_information_file(alternative_rtf_file_path)
        claim_details_page.next

        expect(claim_from_db.uploaded_file_name).to eq 'alt_file.rtf'
      end
    end

    scenario 'Uploading a non text file without submitting' do
      claim_details_page.load
      claim_details_page.rtf_file_upload.expander.click
      claim_details_page.rtf_file_upload.attach_additional_information_file(invalid_file_path)

      pending("An expectation that searches for an error element on the page")
      fail
    end

    scenario 'Uploading a non text file and attempting to submit' do
      claim_details_page.load
      claim_details_page.rtf_file_upload.expander.click
      claim_details_page.rtf_file_upload.attach_additional_information_file(invalid_file_path)
      click_button 'Save and continue'

      expect(claim.uploaded_file_key).not_to be_present
      expect(claim.uploaded_file_name).not_to be_present
    end
  end

  describe 'For additional claimants' do
    let(:csv_file_path) { file_path + './file.csv' }
    let(:alternative_csv_file_path) { file_path + './alt_file.csv' }

    context 'A valid CSV file' do
      before do
        visit '/apply/additional-claimants-upload'
        choose "Yes"
        attach_file "additional_claimants_upload_additional_claimants_csv", csv_file_path
        click_button 'Save and continue'
      end

      scenario 'Attaching the file' do
        expect(claim.reload.additional_claimants_csv_file.read).to eq File.read(csv_file_path)
      end

      scenario 'Deleting the file' do
        visit '/apply/additional-claimants-upload'
        check "additional_claimants_upload_remove_additional_claimants_csv"
        click_button 'Save and continue'

        expect(claim.reload.additional_claimants_csv_file.present?).to be false
      end

      scenario 'Replacing the file' do
        visit '/apply/additional-claimants-upload'
        attach_file "additional_claimants_upload_additional_claimants_csv", alternative_csv_file_path
        click_button 'Save and continue'

        expect(claim.reload.additional_claimants_csv_file.read).to eq File.read(alternative_csv_file_path)
      end
    end

    context 'An invalid file' do
      let(:invalid_csv_path) { file_path + './invalid_file.csv' }

      scenario 'Uploading a CSV file with errors' do
        visit '/apply/additional-claimants-upload'
        choose "Yes"
        attach_file "additional_claimants_upload_additional_claimants_csv", invalid_csv_path

        click_button 'Save and continue'

        expect(page).to have_text('An error has been found on line 4 of the uploaded file.')
        expect(page).to have_text('Postcode - Enter a valid UK postcode. If you live abroad, enter SW55 9QT')
        expect(page).to have_text('Date of birth - Enter the claimant’s date of birth in the correct format (DD/MM/YYYY)')
        expect(claim.additional_claimants_csv).not_to be_present
      end

      scenario 'Uploading a file not of a CSV type' do
        visit '/apply/additional-claimants-upload'
        choose "Yes"
        attach_file "additional_claimants_upload_additional_claimants_csv", invalid_file_path
        click_button 'Save and continue'

        expect(page).to have_text('is not a CSV')
        expect(claim.additional_claimants_csv).not_to be_present
      end
    end
  end
end
