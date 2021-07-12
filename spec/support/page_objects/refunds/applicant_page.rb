require_relative './sections/simple_form'
module ET1
  module Test
    module Refunds
      class ApplicantPage < BasePage
        section :form_error_message, govuk_component(:error_summary), :govuk_error_summary, "Provide information in the highlighted fields."
        # @!method has_name_changed_question
        #   A govuk radio button component for has_name_changed question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        section :has_name_changed_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, 'Has your name changed since you made your employment tribunal claim ?'

        # @!method about_the_claimant
        #   A govuk fieldset component
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        section :about_the_claimant, govuk_component(:fieldset), :govuk_fieldset, 'About you' do
          include EtTestHelpers::Section
          # @!method title_question
          #   A govukselect component wrapping the select, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
          section :title_question, govuk_component(:collection_select), :govuk_collection_select, 'Title'
          # @!method first_name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :first_name_question, govuk_component(:text_field), :govuk_text_field, 'First name'
          # @!method last_name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :last_name_question, govuk_component(:text_field), :govuk_text_field, 'Last name'
          # @!method date_of_birth_question
          #   A govuk date field component wrapping the inputs, label, hint etc.. for a date question
          #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
          section :date_of_birth_question, govuk_component(:date_field), :govuk_date_field, 'Date of birth'

        end

        # @!method claimants_contact_details
        #   A govuk fieldset component
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        section :claimants_contact_details, govuk_component(:fieldset), :govuk_fieldset, 'Your contact details' do
          include EtTestHelpers::Section
          # @!method building_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :building_question, govuk_component(:text_field), :govuk_text_field, 'Building number or name'
          # @!method street_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :street_question, govuk_component(:text_field), :govuk_text_field, 'Street'
          # @!method locality_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :locality_question, govuk_component(:text_field), :govuk_text_field, 'Town/city'
          # @!method county_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :county_question, govuk_component(:text_field), :govuk_text_field, 'County'
          # @!method post_code_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :post_code_question, govuk_component(:text_field), :govuk_text_field, 'UK Postcode'
          # @!method telephone_number_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKPhoneField] The site prism section
          section :telephone_number_question, govuk_component(:phone_field), :govuk_phone_field, 'Phone or mobile number'
          # @!method email_address_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKEmailField] The site prism section
          section :email_address_question, govuk_component(:email_field), :govuk_email_field, 'Email address'
        end
        element :save_and_continue, 'form.edit_refunds_applicant input[value="Continue"]'
      end
    end

  end
end
