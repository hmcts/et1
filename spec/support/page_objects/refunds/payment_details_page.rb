require_relative './sections/simple_form'
module ET1
  module Test
    module Refunds
      class PaymentDetailsPage < BasePage
        set_url "/en/apply/refund/bank-details"
        # @!method account_type_question
        #   A govuk radio button component for account_type question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        section :account_type_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, 'Account type'
        # @!method bank_details
        #   A govuk fieldset component
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        section :bank_details, govuk_component(:fieldset), :govuk_fieldset, 'Your Bank Details' do
          include EtTestHelpers::Section
          # @!method account_name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :account_name_question, govuk_component(:text_field), :govuk_text_field, 'Bank account holder name'
          # @!method bank_name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :bank_name_question, govuk_component(:text_field), :govuk_text_field, 'Bank name'
          # @!method account_number_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :account_number_question, govuk_component(:text_field), :govuk_text_field, 'Bank account number'
          # @!method sort_code_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :sort_code_question, govuk_component(:text_field), :govuk_text_field, 'Bank sort code'
        end
        section :building_society_details, govuk_component(:fieldset), :govuk_fieldset, 'Your Building Society Details' do
          include EtTestHelpers::Section
          # @!method account_name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :account_name_question, govuk_component(:text_field), :govuk_text_field, 'Building Society account holder name'
          # @!method building_society_name_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :building_society_name_question, govuk_component(:text_field), :govuk_text_field, 'Building Society name'
          # @!method account_number_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :account_number_question, govuk_component(:text_field), :govuk_text_field, 'Building Society account number'
          # @!method sort_code_question
          #   A govuk text field component wrapping the input, label, hint etc..
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :sort_code_question, govuk_component(:text_field), :govuk_text_field, 'Building Society sort code'
        end
        element :save_and_continue, 'form.edit_refunds_bank_details input[value="Continue"]'
      end
    end

  end
end
