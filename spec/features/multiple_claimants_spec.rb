require 'rails_helper'

feature 'Multiple claimants', js: true do
  include FormMethods
  include ET1::Test::PageObjectHelpers

  let(:claim) { Claim.create user: User.new(password: 'lollolol') }

  let(:attributes) do
    {
      'First name' => 'Persephone',
      'Last name'  => 'Lollington',

      'Day'   => '15',
      'Month' => '1',
      'Year'  => '1985',

      'Building number or name' => '1',
      'Street'    => 'High street',
      'Town/city' => 'Anytown',
      'County'    => 'Anyfordshire',
      'Postcode'  => 'AT1 4PQ'
    }
  end
  let(:claimant_factory) { build(:ui_secondary_claimant, :default) }

  let(:secondary_attributes) do
    attributes.update 'First name' => 'Pegasus'
  end

  before do
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  describe 'adding claimants' do
    before do
      group_claims_page.load
      group_claims_page.fill_in_all(secondary_claimants: [claimant_factory])
    end

    scenario "filling in a claimant and clicking 'Add more claimants' does not lose the entered details" do
      second_claimant = build(:ui_secondary_claimant, :default)
      expect(page).not_to have_selector '#resource_1'

      group_claims_page.append_secondary_claimants([second_claimant])

      expect(group_claims_page.secondary_claimants).to contain_exactly(claimant_factory, second_claimant)
    end

    scenario 'adding more than one additional claimant' do
      extra_claimant = build(:ui_secondary_claimant, :default)
      group_claims_page
        .append_secondary_claimants([extra_claimant])
        .save_and_continue
      expect(page).not_to have_content("Group claims")
      expect(claim.secondary_claimants.pluck(:last_name)).to contain_exactly(claimant_factory.last_name, extra_claimant.last_name)
    end

    scenario 'a user can still save & complete later' do
      expect(page).to have_signout_button

      click_button "Add more claimants"

      expect(page).to have_signout_button
    end

    scenario "Date of birth form helper text" do
      expect(page).not_to have_selector '#resource_1'
      click_button "Add more claimants"

      expect(page).to have_selector '#resource_1'

      within '#resource_0' do
        expect(page).to have_text('For example, 23 04 1981')
      end

      within '#resource_1' do
        expect(page).to have_text('For example, 23 04 1981')
      end
    end

    context "additional claimants age has to be 16 or over", js: true do
      scenario "display age related error message" do
        expect(page).not_to have_selector '#resource_1'

        click_button "Add more claimants"
        within '#resource_1' do
          sixteen_years_ago = (Time.current - 14.years)
          fill_in 'Day', with: sixteen_years_ago.day.to_s
          fill_in 'Month', with: sixteen_years_ago.month.to_s
          fill_in 'Year', with: sixteen_years_ago.year.to_s
        end

        click_button "Save and continue"
        expect(page).to have_text("Provide information in the highlighted fields")

        within '#resource_1' do
          expect(page).to have_text("Claimant must be 16 years of age or over")
        end

        # This one is older then 16
        within '#resource_0' do
          expect(page).not_to have_text("Claimant must be 16 years of age or over")
        end
      end

      scenario "error message if DoB is missing" do
        expect(page).not_to have_selector '#resource_1'

        click_button "Add more claimants"

        within '#resource_1' do
          select 'Mr', from: 'Title'
          secondary_attributes.each do |field, value|
            fill_in field, with: value
          end

          fill_in 'Day', with: ""
          fill_in 'Month', with: ""
          fill_in 'Year', with: ""
        end

        click_button "Save and continue"
        within '#resource_0' do
          expect(page).not_to have_text("Claimant must be 16 years of age or over")
        end
      end

      scenario "error message if DoB is missing" do
        expect(page).not_to have_selector '#resource_1'

        click_button "Add more claimants"

        within '#resource_1' do
          select 'Mr', from: 'Title'
          secondary_attributes.each do |field, value|
            fill_in field, with: value
          end

          fill_in 'Day', with: "1"
          fill_in 'Month', with: "1"
          fill_in 'Year', with: "12"
        end

        click_button "Save and continue"
        within '#resource_0' do
          expect(page).not_to have_text("Year must be 4 digits")
        end
      end
    end
  end

  describe 'destroying claimants' do
    before do
      add_some_additional_claimants
    end

    scenario 'deleting arbitrary claimants' do
      group_claims_page.load
      group_claims_page.remove_claimant(index: 1)

      expect(page).not_to have_css('#resource_1')

      group_claims_page.save_and_continue
      expect(page).not_to have_content("Group claims")
      expect(claim.secondary_claimants.size).to eq 1
    end
  end

  describe 'indicating there are no additional claimants' do
    scenario 'when no additional claimants have been previously added' do
      group_claims_page.load
      group_claims_page.no_secondary_claimants
      group_claims_page.save_and_continue

      expect(claim.secondary_claimants).to be_empty
      expect(page.current_path).not_to eq claim_additional_claimants_path
    end

    scenario 'when additional claimants have been previously added' do
      add_some_additional_claimants

      group_claims_page.load
      group_claims_page.no_secondary_claimants
      group_claims_page.save_and_continue

      expect(claim.secondary_claimants).to be_empty
      expect(page.current_path).not_to eq claim_additional_claimants_path
    end
  end

  def add_some_additional_claimants
    second_claimant = build(:ui_secondary_claimant, :default)
    group_claims_page.load
    group_claims_page.fill_in_all(secondary_claimants: [claimant_factory, second_claimant])
    group_claims_page.save_and_continue
    expect(page).not_to have_content('Group claims')
  end
end
