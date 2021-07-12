require_relative './base_page'
module ET1
  module Test
    class ResetMemorableWordEmailInstructionsPage < BasePage

      def using(email_address:, claim_number: nil)
        fieldset.email_address_question.set(email_address)
        fieldset.claim_number_question.set(claim_number) unless claim_number.nil?
        fieldset.submit_button.submit
        ReturnToYourClaimPage.new
      end

      private

      # @!method fieldset
      #   A govuk fieldset component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKFieldset] The site prism section
      section :fieldset, govuk_component(:fieldset), :govuk_fieldset, :'reset_memorable_word_instructions.enter_your_details_fieldset' do
        include EtTestHelpers::Section
        # @!method email_address_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        section :email_address_question, govuk_component(:text_field), :govuk_text_field, :'reset_memorable_word_instructions.email_address.label'

        # @!method claim_number_question
        #   A govuk text field component wrapping the input, label, hint etc..
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        section :claim_number_question, govuk_component(:text_field), :govuk_text_field, :'reset_memorable_word_instructions.claim_number.label'

        # @!method submit_button
        #   A govuk submit button component...
        #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
        section :submit_button, govuk_component(:submit), :govuk_submit, :'reset_memorable_word_instructions.reset_memorable_word'
      end
    end
  end
end
