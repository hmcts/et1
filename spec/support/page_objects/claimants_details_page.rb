require_relative './base_page'
module ET1
  module Test
    class ClaimantsDetailsPage < BasePage
      set_url "/en/apply/claimant"


      def fill_in_all(claimant:)
        fill_in_personal_info(claimant: claimant)
        fill_in_special_needs(claimant: claimant)
        fill_in_contact_details(claimant: claimant)
        self
      end
      # Fills in the claimant's personal info
      # @param [Claimant] claimant The claimant
      def fill_in_personal_info(claimant:)
        about_the_claimant_group.tap do |s|
          s.title_question.set(claimant.title)
          s.first_name_question.set(claimant.first_name)
          s.last_name_question.set(claimant.last_name)
          s.date_of_birth_question.set(claimant.date_of_birth)
          s.gender_question.set(claimant.gender)
        end
      end

      # Fills in the special needs section
      # @param [Boolean] has_special_needs A boolean to indicate if the claimant has special needs or not
      # @param [String, NilClass] special_needs A string containing the special needs to fill in (nil if not needed)
      def fill_in_special_needs(claimant:)
        about_the_claimant_group.tap do |s|
          s.has_special_needs_question.set(claimant.has_special_needs)
          s.special_needs_question.set(claimant.special_needs) if claimant.has_special_needs
        end
      end

      # Fills in the contact details section
      # @param [Claimant] claimant The claimant
      def fill_in_contact_details(claimant:)
        claimants_contact_details_group.tap do |s|
          s.building_question.set(claimant.address_building)
          s.street_question.set(claimant.address_street)
          s.town_question.set(claimant.address_town)
          s.county_question.set(claimant.address_county)
          s.post_code_question.set(claimant.address_post_code)
          s.country_question.set(claimant.address_country)
          s.phone_or_mobile_number_question.set(claimant.phone_or_mobile_number)
          s.alternative_phone_or_mobile_number_question.set(claimant.alternative_phone_or_mobile_number)
          s.best_correspondence_method_question.set(claimant.best_correspondence_method)
          s.email_address_question.set(claimant.email_address) if claimant.best_correspondence_method.to_s.split('.').last == 'email'
          s.allow_video_attendance_question.set(claimant.allow_video_attendance)
        end
      end

      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
      end

      def save_and_complete_later
        save_and_complete_later_element.click
        SaveAndCompleteLaterPage.new
      end


      # @param [Hash] error_messages A list of error messages keyed by the question name (ignoring groups)
      def assert_error_messages(error_messages)
        aggregate_failures 'validating error messages' do
          error_messages.each_pair do |question_prefix, expected_message|
            question = :"#{question_prefix}_question"
            [:about_the_claimant_group, :claimants_contact_details_group].any? do |group|
              next unless send(group).respond_to?(question)
              send(group).send(question).assert_error_message(t(expected_message))
            end
          end

        end
      end

      private

      section :about_the_claimant_group, :fieldset_translated, 'claimants_details.about_the_claimant_group' do
        include EtTestHelpers::Section
        # @!method title_question
        #   A govukselect component wrapping the select, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
        section :title_question, govuk_component(:collection_select), :govuk_collection_select, :'claimants_details.title.label'

        # @!method first_name_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        section :first_name_question, govuk_component(:text_field), :govuk_text_field, :'claimants_details.first_name.label'

        # @!method govuk_text_field
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        section :last_name_question, govuk_component(:text_field), :govuk_text_field, :'claimants_details.last_name.label'

        # @!method date_of_birth_question
        #   A govuk date field component wrapping the input, label, hint etc.. for the date of birth question
        #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
        section :date_of_birth_question, govuk_component(:date_field), :govuk_date_field, :'claimants_details.date_of_birth.label'

        # @!method gender_question
        #   A govuk radio button component for the gender question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        section :gender_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'claimants_details.gender.label'

        # @!method has_special_needs_question
        #   A govuk radio button component for the has special needs question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        section :has_special_needs_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'claimants_details.has_special_needs.label'

        # @!method special_needs_question
        #   A govuk text area component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextArea] The site prism section
        section :special_needs_question, govuk_component(:text_area), :govuk_text_area, :'claimants_details.special_needs.label'
      end

      section :claimants_contact_details_group, :fieldset_translated, 'claimants_details.claimants_contact_details_group' do
        include EtTestHelpers::Section
        # @!method building_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        section :building_question, govuk_component(:text_field), :govuk_text_field, :'claimants_details.building.label'

        # @!method street_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        section :street_question, govuk_component(:text_field), :govuk_text_field, :'claimants_details.street.label'

        # @!method town_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        section :town_question, govuk_component(:text_field), :govuk_text_field, :'claimants_details.town.label'

        # @!method county_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        section :county_question, govuk_component(:text_field), :govuk_text_field, :'claimants_details.county.label'

        # @!method post_code_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        section :post_code_question, govuk_component(:text_field), :govuk_text_field, :'claimants_details.post_code.label'

        # @!method country_question
        #   A govukselect component wrapping the select, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
        section :country_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'claimants_details.country.label'

        # @!method phone_or_mobile_number_question
        #   A govuk phone field component representing the phone or mobile question
        #   @return [EtTestHelpers::Components::GovUKPhoneField] The site prism section
        section :phone_or_mobile_number_question, govuk_component(:phone_field), :govuk_phone_field, :'claimants_details.phone_or_mobile_number.label'

        # @!method alternative_phone_or_mobile_number_question
        #   A govuk phone field component representing the alternative phone or mobile question
        #   @return [EtTestHelpers::Components::GovUKPhoneField] The site prism section
        section :alternative_phone_or_mobile_number_question, govuk_component(:phone_field), :govuk_phone_field, :'claimants_details.alternative_phone_or_mobile_number.label'

        # @!method email_address_question
        #   A govuk email field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKEmailField] The site prism section
        section :email_address_question, govuk_component(:email_field), :govuk_email_field, :'claimants_details.email_address.label'

        # @!method best_correspondence_method_question
        #   A govuk radio button component for the gender question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        section :best_correspondence_method_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'claimants_details.best_correspondence_method.label'
        # @!method allow_video_attendance_question
        #   A govuk radio button component for the video question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        section :allow_video_attendance_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'claimants_details.allow_video_attendance.label'
      end

      # @!method save_and_continue_button
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      section :save_and_continue_button, govuk_component(:submit), :govuk_submit, :'claimants_details.save_and_continue'
      element :save_and_complete_later_element, :link_or_button_translated, 'claimants_details.save_and_complete_later'

    end
  end
end
