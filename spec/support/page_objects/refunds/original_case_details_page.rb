require_relative './sections/simple_form'
module ET1
  module Test
    module Refunds
      class OriginalCaseDetailsPage < BasePage
        section :original_case_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your case details")]] }) do
          include EtTestHelpers::Section
          # @!method et_country_of_claim_question
          #   A govukselect component wrapping the select, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
          section :et_country_of_claim_question, govuk_component(:collection_select), :govuk_collection_select, 'Where was your claim issued?'
          # @!method et_case_number_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :et_case_number_question, govuk_component(:text_field), :govuk_text_field, 'Employment tribunal case number'
          # @!method eat_case_number_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :eat_case_number_question, govuk_component(:text_field), :govuk_text_field, 'Employment appeal tribunal case number'
          # @!method et_tribunal_office_question
          #   A govukselect component wrapping the select, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
          section :et_tribunal_office_question, govuk_component(:collection_select), :govuk_collection_select, 'Employment tribunal office'
          # @!method additional_information_question
          #   A govuk text area component wrapping the input, label, hint etc.. for a text area
          #   @return [EtTestHelpers::Components::GovUKTextArea] The site prism section
          section :additional_information_question, govuk_component(:text_area), :govuk_text_area, 'Additional information'
        end
        section :original_claimant_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your address at the time of your claim")]] }) do
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
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :telephone_number_question, govuk_component(:text_field), :govuk_text_field, 'Phone or mobile number'
          # @!method email_address_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :email_address_question, govuk_component(:text_field), :govuk_text_field, 'Email address'
        end
        section :original_respondent_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Respondent")]] }) do
          include EtTestHelpers::Section
          # @!method name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :name_question, govuk_component(:text_field), :govuk_text_field, 'Respondent name'
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
        end
        # @!method claim_had_representative_question
        #   A govuk radio button component for claim_had_representative question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        section :claim_had_representative_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, 'Did you have a representative at the time of your original claim ?'
        section :original_representative_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Representative")]] }) do
          include EtTestHelpers::Section
          # @!method name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :name_question, govuk_component(:text_field), :govuk_text_field, 'Representative name'
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
        end
        # @!method address_changed_question
        #   A govuk radio button component for address_changed question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        section :address_changed_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, "Has your address changed since you made your employment tribunal claim ?"
        element :save_and_continue, 'form.edit_refunds_original_case_details input[value="Continue"]'
      end
    end

  end
end
