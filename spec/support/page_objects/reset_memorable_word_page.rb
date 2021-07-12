require_relative './base_page'
module ET1
  module Test
    class ResetMemorableWordPage < BasePage

      def set_memorable_word(value)
        memorable_word_question.set(value)
        submit_button.submit
        ReturnToYourClaimPage.new
      end

      # @param [String] email_address
      # @return [ET1::Test::ResetMemorableWordPage]
      # Loads the memorable word page referenced in the email for a specific email address
      def from_email_for(email_address)
        email = Et1::Test::EmailObjects::ResetPasswordEmailHtml.find(email_address: email_address)
        raise Capybara::ElementNotFound, "Email not found for #{email_address}" if email.nil?
        visit email.reset_memorable_word_path
        self
      end

      private

      # @!method memorable_word_element
      #   A govuk text field component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      section :memorable_word_question, govuk_component(:text_field), :govuk_text_field, :'reset_memorable_word.memorable_word.label'

      # @!method submit_button
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      section :submit_button, govuk_component(:submit), :govuk_submit, :'reset_memorable_word.reset_memorable_word'
    end
  end
end
