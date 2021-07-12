require 'rails_helper'

feature 'Claimant page', js: true do
  include FormMethods

  let(:claim) { Claim.create user: User.new(password: 'lollolol') }

  let(:attributes) do
    {
      'First name' => 'Persephone',
      'Last name'  => 'Lollington',
      'Building number or name' => '1',
      'Street'    => 'High street',
      'Town/city' => 'Anytown',
      'County'    => 'Anyfordshire',
      'Postcode'  => 'AT1 4PQ'
    }
  end

  let(:ui_claimant) { build(:ui_claimant, :default) }

  let(:secondary_attributes) do
    attributes.update 'First name' => 'Pegasus'
  end

  before do
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  describe 'adding claimant that is 16 or more years older' do
    before do
      claimants_details_page.fill_in_all(claimant: ui_claimant)
    end

    context 'under 16 years old' do
      let(:ui_claimant) { build(:ui_claimant, :default, :under_age) }

      it "displays DOB validation above dob field" do
        claimants_details_page.save_and_continue
        expect(page).to have_text("Provide information in the highlighted fields")

        claimants_details_page.about_the_claimant_group.date_of_birth_question.assert_error_message('Claimant must be 16 years of age or over')
      end
    end

    context 'over 16 years old' do
      it "displays no validation if older then 16" do
        claimants_details_page.save_and_continue

        expect(page).not_to have_text("Provide information in the highlighted fields")
      end
    end

    context 'no dob present' do
      let(:ui_claimant) { build(:ui_claimant, :default, :no_date_of_birth) }

      it "displays validation if no DOB is present" do
        claimants_details_page.save_and_continue
        expect(page).to have_text("Provide information in the highlighted fields")
        claimants_details_page.about_the_claimant_group.date_of_birth_question.assert_error_message('Claimant must be 16 years of age or over')
      end
    end

    context 'dob is 2 digit year' do
      let(:ui_claimant) { build(:ui_claimant, :default, :date_of_birth_two_digit) }

      it "displays validation of DOB is 2 digits" do
        claimants_details_page.save_and_continue
        expect(page).to have_text("Provide information in the highlighted fields")
        claimants_details_page.about_the_claimant_group.date_of_birth_question.assert_error_message('Enter the claimant’s date of birth in the correct format (DD/MM/YYYY)')
      end
    end

    context 'with no video question present' do
      let(:ui_claimant) { build(:ui_claimant, :default, :no_allow_video_attendance) }

      it "displays validation if no allow video attendance is present" do
        click_button "Save and continue"
        expect(page).to have_text("Please say whether you would be able to attend a hearing by video")
      end
    end

  end
end
