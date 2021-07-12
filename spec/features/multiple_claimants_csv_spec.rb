require 'rails_helper'

feature 'Multiple claimants CSV' do
  include FormMethods

  let(:claim) { Claim.create user: User.new(password: 'lollolol') }
  let(:file_path) do
    csv_string = CSV.generate do |csv|
      csv << ["Title", "First name", "Last name", "Date of birth", "Building number or name", "Street", "Town/city", "County", "Postcode"]
      csv << csv_line
    end
    begin
      file = Tempfile.new('test')
      file.write(csv_string)
      file.path
    ensure
      file&.close
    end
  end

  before do
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  describe 'adding claimants' do
    before do
      group_claims_upload_page.load
    end

    context "group claimants age has to be 16 or over" do
      let(:csv_line) { ["Mr", "Tom", "Test", "01/01/2016", "1", "Test", "London", "Great London", "N103QS"] }

      scenario "if claimant is too young" do
        group_claims_upload_page.upload_secondary_claimants_csv(file_path).save_and_continue

        expect(page).to have_text("An error has been found on line 2 of the uploaded file.")
        expect(page).to have_text("Date of birth - Claimant must be 16 years of age or over")
      end

      context 'dob is missing' do
        let(:csv_line) { ["Mr", "Tom", "Test", "", "1", "Test", "London", "Great London", "N103QS"] }

        scenario "error is displayed" do
          group_claims_upload_page.upload_secondary_claimants_csv(file_path).save_and_continue

          expect(page).to have_text("An error has been found on line 2 of the uploaded file.")
          expect(page).to have_text("Date of birth - Claimant must be 16 years of age or over")
        end
      end

      context "incorrect format" do
        let(:csv_line) { ["Mr", "Tom", "Test", "15-12-74", "1", "Test", "London", "Great London", "N103QS"] }

        scenario "with dashes" do
          group_claims_upload_page.upload_secondary_claimants_csv(file_path).save_and_continue
          expect(page).to have_text("For dates of birth, use numbers and/or letters separated by forward slashes. Eg 23/04/1983 or 23/Apr/1983")
        end
      end

      context "Allow month names" do
        let(:csv_line) { ["Mr", "Tom", "Test", "15/Dec/74", "1", "Test", "London", "Great London", "N103QS"] }

        scenario "as text" do
          group_claims_upload_page.upload_secondary_claimants_csv(file_path).save_and_continue
          expect(page).not_to have_text("For dates of birth, use numbers and/or letters separated by forward slashes. Eg 23/04/1983 or 23/Apr/1983")
        end
      end

      context 'all data are ok' do
        let(:csv_line) { ["Mr", "Tom", "Test", "01/01/1990", "1", "Test", "London", "Great London", "N103QS"] }

        scenario "no error displayed" do
          group_claims_upload_page.upload_secondary_claimants_csv(file_path).save_and_continue

          expect(page).not_to have_text("An error has been found")
          expect(page).not_to have_text("Date of birth - Claimant must be 16 years of age or over")
        end
      end
    end
  end
end
