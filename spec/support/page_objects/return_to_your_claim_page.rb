require_relative './base_page'
module ET1
  module Test
    class ReturnToYourClaimPage < BasePage
      set_url '/en/apply/users/sign_in'

      def assert_missing_claim_number
        invalid_word_or_number_flash_element
      end

      def return_to_your_claim(claim_number:, memorable_word:)
        memorable_word_element.set(memorable_word) unless memorable_word.nil?
        claim_number_element.set(claim_number) unless claim_number.nil?
        submit_button.submit
      end

      def reset_memorable_word
        reset_memorable_word_element.click
        ResetMemorableWordEmailInstructionsPage.new
      end

      def assert_memorable_word_email_sent
        memorable_word_email_sent_flash_element
      end

      private

      # @!method memorable_word_element
      #   A govuk text field component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      section :memorable_word_element, govuk_component(:text_field), :govuk_text_field, :'return_to_your_claim.memorable_word.label'
      # @!method claim_number_element
      #   A govuk text field component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      section :claim_number_element, govuk_component(:text_field), :govuk_text_field, :'return_to_your_claim.save_and_return_number.label'

      element :reset_memorable_word_element, :link, 'Click here to reset'

      # @!method submit_button
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      section :submit_button, govuk_component(:submit), :govuk_submit, :'return_to_your_claim.find_my_claim'
      element :memorable_word_email_sent_flash_element, '#flash-summary *', text: 'You will receive an email with instructions on how to reset your memorable word in a few minutes'
      element :invalid_word_or_number_flash_element, '#flash-summary *', text: "Invalid memorable word or save and return number, please check and try again."
    end
  end
end
