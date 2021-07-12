require_relative './base_page'
module ET1
  module Test
    class GroupClaimsPage < BasePage
      set_url "/en/apply/additional-claimants"

      # Adds a list of secondary claimants using the user interface
      # If the list is not empty - it clicks "Yes" to the 'People making a claim with you'
      # question, then fills in the sections below it.
      # This is limited to  a max of 5 secondary claimants.
      # Any more than that, the user will need to call provide_spreadsheet and then use
      # the GroupClaimsUploadPage page object to upload the spreadsheet
      # If the list is empty - it clicks "No" to the 'People making a claim with you'
      # @param [Array<Claimant>] secondary_claimants An array of claimants to add
      def fill_in_all(secondary_claimants:)
        if secondary_claimants.nil? || secondary_claimants.empty?
          no_secondary_claimants
        else
          add_secondary_claimants(secondary_claimants)
        end
        self
      end

      # Remove a secondary claimant already present
      # @param [Integer] index Zero based position of secondary claimant to remove
      def remove_claimant(index:)
        claimant_section(index: index).remove
        self
      end

      def append_secondary_claimants(claimants)
        return if claimants.nil? || claimants.empty?
        starting_index = secondary_claimant_sections.last.index

        claimants.each_with_index do |claimant, index|
          add_claimant_section
          claimant_section(index: index + starting_index + 1).set(claimant)
        end
        self
      end

      def secondary_claimants
        secondary_claimant_sections.map do |s|
          ET1::Test::SecondaryClaimantUi.new.tap do |obj|
            obj.title = title_to_i18n(s.title.value)
            obj.first_name = s.first_name.value
            obj.last_name = s.last_name.value
            obj.date_of_birth = date_to_user(s.date_of_birth.value)
            obj.address_building = s.building.value
            obj.address_street = s.street.value
            obj.address_town = s.town.value
            obj.address_county = s.county.value
            obj.address_post_code = s.post_code.value
          end
        end
      end

      # Clicks on the link to provide the spreadsheet instead of using the user interface
      def provide_spreadsheet
        people_making_claim_with_you_question.set(:'group_claims.people_making_claim_with_you.options.yes')
        provide_spreadsheet_element.click
        GroupClaimsUploadPage.new
      end

      # Clicks on no to the primary question of 'People making a claim with you'
      def no_secondary_claimants
        people_making_claim_with_you_question.set(:'group_claims.people_making_claim_with_you.options.no')
        self
      end

      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
      end

      private

      def add_secondary_claimants(claimants)
        if claimants.nil? || claimants.empty?
          people_making_claim_with_you_question.set(:'group_claims.people_making_claim_with_you.options.no')
          return
        end

        people_making_claim_with_you_question.set(:'group_claims.people_making_claim_with_you.options.yes')
        claimants.each_with_index do |claimant, index|
          add_claimant_section unless index.zero?
          claimant_section(index: index).set(claimant)
        end
      end

      class ClaimantSection < BaseSection
        def set(claimant)
          title.set(claimant.title)
          first_name.set(claimant.first_name)
          last_name.set(claimant.last_name)
          date_of_birth.set(claimant.date_of_birth)
          building.set(claimant.address_building)
          street.set(claimant.address_street)
          town.set(claimant.address_town)
          county.set(claimant.address_county)
          post_code.set(claimant.address_post_code)
        end

        def index
          fieldset.claimant_number.text.match(/(\d*)\z/)[0].to_i - 2
        end

        def remove
          remove_this_claimant_element.click
        end

        private

        section :fieldset, :xpath, XPath.generate {| x| x.child(:fieldset) } do
          element :claimant_number, :xpath, XPath.generate { |x| x.child(:legend) }
        end
        section :title, govuk_component(:collection_select), :govuk_collection_select, :'claimants_details.title.label'
        section :first_name, govuk_component(:text_field), :govuk_text_field, :'claimants_details.first_name.label'
        section :last_name, govuk_component(:text_field), :govuk_text_field, :'claimants_details.last_name.label'
        section :date_of_birth, govuk_component(:date_field), :govuk_date_field, :'claimants_details.date_of_birth.label'
        section :building, govuk_component(:text_field), :govuk_text_field, :'claimants_details.building.label'
        section :street, govuk_component(:text_field), :govuk_text_field, :'claimants_details.street.label'
        section :town, govuk_component(:text_field), :govuk_text_field, :'claimants_details.town.label'
        section :county, govuk_component(:text_field), :govuk_text_field, :'claimants_details.county.label'
        section :post_code, govuk_component(:text_field), :govuk_text_field, :'claimants_details.post_code.label'
        element :remove_this_claimant_element, :link, t('claimants_details.remove_this_claimant')
      end

      def date_to_user(date)
        return nil if date.nil?

        date.strftime('%d/%m/%Y')
      end

      def title_to_i18n(title)
        titles = t('claimants_details.title.options')
        key = titles.key(title)
        return nil if key.nil?

        :"claimants_details.title.options.#{key}"
      end

      def add_claimant_section
        add_more_claimants_action.submit
      end

      def claimant_section(index:)
        ClaimantSection.new(self, find(:xpath, XPath.generate {|x| x.descendant(:div)[x.attr(:class).contains_word('multiple') & x.child(:fieldset)[x.child(:legend)[x.string.n.equals(t('group_claims.claimant_section.label', number: index +2))]]]}))
      end

      # @!method govuk_radios
      #   A govuk radio button component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      section :people_making_claim_with_you_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'group_claims.people_making_claim_with_you.label'

      # @!method add_more_claimants_action
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKErrorSummary] The site prism section
      section :add_more_claimants_action, govuk_component(:submit), :govuk_submit, :'group_claims.add_more_claimants.label'

      sections :secondary_claimant_sections, ClaimantSection, :xpath, XPath.generate {|x| x.descendant(:div)[x.attr(:class).contains_word('multiple')]}

      element :provide_spreadsheet_element, :link, 'upload their details in a separate spreadsheet'

      # @!method save_and_continue_button
      #   A govuk submit button component for the save and continue button
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      section :save_and_continue_button, govuk_component(:submit), :govuk_submit, :'group_claims.save_and_continue'

    end
  end
end
