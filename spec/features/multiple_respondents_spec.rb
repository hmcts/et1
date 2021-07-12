require 'rails_helper'

feature 'Multiple respondents', js: true do
  include FormMethods

  let(:claim) { Claim.create user: User.new(password: 'lollolol') }
  let(:ui_secondary_respondents) { build_list(:ui_secondary_respondent, 1, :default) }

  before do
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  describe 'adding respondents' do
    before do
      additional_respondents_page.load
      additional_respondents_page.fill_in_all(secondary_respondents: ui_secondary_respondents)
    end

    scenario "filling in a respondent and clicking 'Add another respondent' does not lose the entered details" do
      extra_ui_respondent = build(:ui_secondary_respondent, :default)
      expect(page).not_to have_selector '#resource_1'

      additional_respondents_page.append_secondary_respondents([extra_ui_respondent])
      expect(additional_respondents_page.secondary_respondents).to match_array(ui_secondary_respondents + [extra_ui_respondent])
    end

    scenario 'adding more than one additional respondent' do
      extra_ui_respondent = build(:ui_secondary_respondent, :default)
      additional_respondents_page
        .append_secondary_respondents([extra_ui_respondent])
        .save_and_continue

      employment_details_page.wait_until_displayed
      claim.reload
      expect(claim.secondary_respondents.pluck(:name)).
        to match_array (ui_secondary_respondents + [extra_ui_respondent]).map(&:name)
    end
  end

  describe 'destroying respondents' do
    before { add_some_additional_respondents }

    scenario 'deleting arbitrary respondents' do
      additional_respondents_page.load
      expect(claim.secondary_respondents.count).to eq 2
      additional_respondents_page
        .remove_respondent(index: 0)
        .save_and_continue
      employment_details_page.wait_until_displayed
      expect(claim.secondary_respondents.count).to eq 1
    end
  end

  describe 'indicating there are no additional respondents' do
    scenario 'when no additional respondents have been previously added' do
      additional_respondents_page.load
      additional_respondents_page
        .fill_in_all(secondary_respondents: [])
        .save_and_continue
      employment_details_page.wait_until_displayed
      expect(claim.secondary_respondents).to be_empty
    end

    scenario 'when additional respondents have been previously added' do
      add_some_additional_respondents

      additional_respondents_page.load
      additional_respondents_page
        .fill_in_all(secondary_respondents: [])
        .save_and_continue
      employment_details_page.wait_until_displayed
      expect(claim.secondary_respondents).to be_empty
    end
  end

  def add_some_additional_respondents
    second_ui_respondent = build(:ui_secondary_respondent, :default)
    additional_respondents_page.load
    additional_respondents_page
      .fill_in_all(secondary_respondents: ui_secondary_respondents + [second_ui_respondent])
      .save_and_continue
  end
end
